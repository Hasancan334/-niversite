import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/app_colors.dart';

/// Gizli yönetici ekranı: JSON yapıştır -> Yayınla.
/// Giriş: Firebase Authentication (e-posta / şifre).
class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _email = TextEditingController();
  final _sifre = TextEditingController();
  final _json = TextEditingController();

  String _koleksiyon = 'duyuru_etkinlik';
  bool _yukleniyor = false;
  String? _mesaj;
  bool _hata = false;

  static const _koleksiyonlar = {
    'duyuru_etkinlik': 'Duyuru / Etkinlik',
    'is_ilanlari': 'İş ilanı',
    'mekanlar': 'Mekan',
    'yemekler': 'Yemek',
  };

  // Koleksiyona göre geçerli "tip" değerleri (null = kontrol yok)
  static const _gecerliTipler = {
    'duyuru_etkinlik': ['duyuru', 'etkinlik'],
    'is_ilanlari': ['gunluk', 'yari_zamanli'],
  };

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _email.dispose();
    _sifre.dispose();
    _json.dispose();
    super.dispose();
  }

  void _bildir(String m, {bool hata = false}) {
    if (!mounted) return;
    setState(() {
      _mesaj = m;
      _hata = hata;
    });
  }

  Future<void> _girisYap() async {
    setState(() => _yukleniyor = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _sifre.text,
      );
      _bildir('Giriş yapıldı');
    } on FirebaseAuthException catch (e) {
      _bildir('Giriş başarısız: ${e.code}', hata: true);
    } catch (e) {
      _bildir('Giriş başarısız: $e', hata: true);
    }
    if (mounted) setState(() => _yukleniyor = false);
  }

  Future<void> _cikis() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) setState(() => _mesaj = null);
  }

  Future<void> _yapistir() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      setState(() => _json.text = data!.text!);
    }
  }

  Future<void> _yayinla() async {
    final metin = _json.text.trim();
    if (metin.isEmpty) {
      _bildir('Önce JSON yapıştır', hata: true);
      return;
    }

    dynamic cozulen;
    try {
      cozulen = jsonDecode(metin);
    } catch (e) {
      _bildir('JSON okunamadı. Tırnak ve virgülleri kontrol et.\n$e',
          hata: true);
      return;
    }

    // Desteklenen biçimler:
    //  1) tek kayıt:            {"baslik": ...}
    //  2) liste:                [ {...}, {...} ]
    //  3) sarmalanmış:          {"is_ilanlari": {"ilan_001": {...}, ...}}
    //  4) kimlikli kayıtlar:    {"ilan_001": {...}, "ilan_002": {...}}
    String koleksiyon = _koleksiyon;
    final kayitlar = <MapEntry<String?, dynamic>>[];

    bool tumuMap(Map m) => m.isNotEmpty && m.values.every((v) => v is Map);

    if (cozulen is List) {
      for (final k in cozulen) {
        kayitlar.add(MapEntry(null, k));
      }
    } else if (cozulen is Map) {
      Map ic = cozulen;
      if (ic.length == 1 &&
          _koleksiyonlar.containsKey(ic.keys.first) &&
          ic.values.first is Map &&
          tumuMap(ic.values.first as Map)) {
        koleksiyon = ic.keys.first as String;
        ic = ic.values.first as Map;
      }
      if (!ic.containsKey('baslik') && !ic.containsKey('tarih') && tumuMap(ic)) {
        ic.forEach((id, v) => kayitlar.add(MapEntry(id.toString(), v)));
      } else {
        kayitlar.add(MapEntry(null, ic));
      }
    } else {
      _bildir('JSON bir nesne ya da liste olmalı', hata: true);
      return;
    }

    final tipler = _gecerliTipler[koleksiyon];

    // Önce hepsini doğrula, hata varsa hiçbirini yazma
    for (var i = 0; i < kayitlar.length; i++) {
      final k = kayitlar[i].value;
      if (k is! Map) {
        _bildir('${i + 1}. kayıt bir JSON nesnesi değil', hata: true);
        return;
      }
      if (tipler != null && !tipler.contains(k['tip'])) {
        _bildir(
            '${i + 1}. kayıtta "tip" şunlardan biri olmalı: ${tipler.join(', ')}',
            hata: true);
        return;
      }
    }

    setState(() => _yukleniyor = true);
    try {
      final db = FirebaseFirestore.instance;
      // Firestore batch en fazla 500 işlem
      for (var baslangic = 0; baslangic < kayitlar.length; baslangic += 400) {
        final batch = db.batch();
        final son = (baslangic + 400 < kayitlar.length)
            ? baslangic + 400
            : kayitlar.length;
        for (var i = baslangic; i < son; i++) {
          final veri = Map<String, dynamic>.from(kayitlar[i].value as Map);
          veri.putIfAbsent('aktif', () => true);
          veri['eklenme'] = FieldValue.serverTimestamp();
          final id = kayitlar[i].key;
          // Kimlik verildiyse aynı kayıt tekrar yüklenince üzerine yazılır
          final ref = id != null
              ? db.collection(koleksiyon).doc(id)
              : db.collection(koleksiyon).doc();
          batch.set(ref, veri);
        }
        await batch.commit();
      }
      _json.clear();
      _bildir('✅ ${kayitlar.length} kayıt yayınlandı ($koleksiyon)');
    } on FirebaseException catch (e) {
      _bildir('Yazılamadı: ${e.code}\n(Firestore kurallarını kontrol et)',
          hata: true);
    } catch (e) {
      _bildir('Hata: $e', hata: true);
    }
    if (mounted) setState(() => _yukleniyor = false);
  }

  Widget _girisFormu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              labelText: 'E-posta', border: OutlineInputBorder()),
        ),
        SizedBox(height: 12),
        TextField(
          controller: _sifre,
          obscureText: true,
          decoration:
          InputDecoration(labelText: 'Şifre', border: OutlineInputBorder()),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _yukleniyor ? null : _girisYap,
          child: Text('Giriş yap'),
        ),
      ],
    );
  }

  Widget _panel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Giriş: ${_user?.email ?? ''}',
            style: TextStyle(color: AppColors.textSecondary)),
        SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _koleksiyon,
          decoration: InputDecoration(
              labelText: 'Nereye eklenecek?', border: OutlineInputBorder()),
          items: _koleksiyonlar.entries
              .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
              .toList(),
          onChanged: (v) => setState(() => _koleksiyon = v ?? _koleksiyon),
        ),
        SizedBox(height: 12),
        TextField(
          controller: _json,
          maxLines: 12,
          style: TextStyle(fontFamily: 'monospace', fontSize: 13),
          decoration: InputDecoration(
            labelText: 'JSON (tek kayıt ya da liste)',
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _yapistir,
                icon: Icon(Icons.paste),
                label: Text('Yapıştır'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _json.clear()),
                icon: Icon(Icons.clear),
                label: Text('Temizle'),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _yukleniyor ? null : _yayinla,
          icon: Icon(Icons.publish),
          label: Text('YAYINLA'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final girisli = _user != null;
    return Scaffold(
      appBar: AppBar(
        title: Text('YÖNETİCİ'),
        actions: [
          if (girisli)
            IconButton(
              icon: Icon(Icons.logout),
              tooltip: 'Çıkış',
              onPressed: _cikis,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (girisli) _panel() else _girisFormu(),
            if (_yukleniyor)
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (_mesaj != null)
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  _mesaj!,
                  style: TextStyle(
                    color: _hata ? AppColors.error : AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}