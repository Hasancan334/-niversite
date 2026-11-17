import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_colors.dart';
import '../l10n/dil.dart';

/// Günün yemeğine yapılan yorumlar.
/// Firestore: yemek_yorumlari/{otomatik}  { gun: 20261117, yorum, isim, zaman }
/// Takma ad sohbet odasıyla ortak ('sohbet_isim').
class YemekYorumlari {
  static const koleksiyon = 'yemek_yorumlari';

  /// 2026-11-17 -> 20261117
  static int gunKodu(DateTime t) => t.year * 10000 + t.month * 100 + t.day;

  static Query<Map<String, dynamic>> sorgu(int gun) => FirebaseFirestore
      .instance
      .collection(koleksiyon)
      .where('gun', isEqualTo: gun)
      .limit(300);

  static void ac(BuildContext context, DateTime gun, String baslik) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _YorumSayfasi(gun: gunKodu(gun), baslik: baslik),
    );
  }
}

/// Kartın altındaki "💬 Yorumlar (3)" düğmesi
class YorumButonu extends StatelessWidget {
  final DateTime gun;
  final String baslik;
  final Color renk;
  const YorumButonu(
      {required this.gun, required this.baslik, required this.renk});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: YemekYorumlari.sorgu(YemekYorumlari.gunKodu(gun)).snapshots(),
      builder: (context, snap) {
        final n = snap.data?.docs.length ?? 0;
        return Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: renk,
              padding: EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => YemekYorumlari.ac(context, gun, baslik),
            icon: Icon(Icons.chat_bubble_outline, size: 16),
            label: Text(
              n == 0
                  ? tx('Yorum yap', 'Reageer', 'Comment')
                  : tx('Yorumlar ($n)', 'Reacties ($n)', 'Comments ($n)'),
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}

class _YorumSayfasi extends StatefulWidget {
  final int gun;
  final String baslik;
  const _YorumSayfasi({required this.gun, required this.baslik});

  @override
  State<_YorumSayfasi> createState() => _YorumSayfasiState();
}

class _YorumSayfasiState extends State<_YorumSayfasi> {
  final _controller = TextEditingController();
  String? _isim;
  bool _gonderiliyor = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      if (mounted) setState(() => _isim = p.getString('sohbet_isim'));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String?> _isimSor() async {
    final c = TextEditingController();
    final isim = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tx('Takma adın?', 'Je bijnaam?', 'Your nickname?')),
        content: TextField(
          controller: c,
          maxLength: 15,
          autofocus: true,
          decoration:
              InputDecoration(hintText: tx('Örn: Ahmet', 'Bijv. Sanne', 'E.g. Alex')),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final t = c.text.trim();
              if (t.isNotEmpty) Navigator.pop(ctx, t);
            },
            child: Text(tx('Tamam', 'OK', 'OK')),
          ),
        ],
      ),
    );
    if (isim == null) return null;
    final p = await SharedPreferences.getInstance();
    await p.setString('sohbet_isim', isim);
    if (mounted) setState(() => _isim = isim);
    return isim;
  }

  Future<void> _gonder() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _gonderiliyor) return;
    final isim = _isim ?? await _isimSor();
    if (isim == null) return;
    setState(() => _gonderiliyor = true);
    try {
      await FirebaseFirestore.instance.collection(YemekYorumlari.koleksiyon).add({
        'gun': widget.gun,
        'yorum': text,
        'isim': isim,
        'zaman': FieldValue.serverTimestamp(),
      });
      _controller.clear();
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(tx('Yorum gönderilemedi (${e.code})',
                'Reactie niet verzonden (${e.code})',
                'Comment not sent (${e.code})'))));
      }
    }
    if (mounted) setState(() => _gonderiliyor = false);
  }

  Future<void> _sikayetEt(String id, Map<String, dynamic> d) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tx('Yorumu şikayet et', 'Reactie melden', 'Report comment')),
        content: Text(tx('Bu yorum uygunsuz içerik barındırıyor mu?',
            'Bevat deze reactie ongepaste inhoud?',
            'Does this comment contain inappropriate content?')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(tx('Vazgeç', 'Annuleren', 'Cancel'))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(tx('Şikayet et', 'Melden', 'Report'))),
        ],
      ),
    );
    if (onay != true) return;
    await FirebaseFirestore.instance.collection('sikayetler').add({
      'tur': 'yemek_yorum',
      'mesajId': id,
      'mesaj': d['yorum'],
      'isim': d['isim'],
      'zaman': FieldValue.serverTimestamp(),
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(tx('Şikayetiniz alındı, teşekkürler.',
              'Bedankt, je melding is ontvangen.',
              'Thanks, your report has been received.'))));
    }
  }

  DateTime _zaman(Map<String, dynamic> d) {
    final z = d['zaman'];
    return z is Timestamp ? z.toDate() : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final alt = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: alt),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Row(
                children: [
                  Icon(Icons.restaurant_menu, color: AppColors.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.baslik,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: YemekYorumlari.sorgu(widget.gun).snapshots(),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(
                        child: Text(tx('Yorumlar yüklenemedi',
                            'Reacties konden niet worden geladen',
                            'Comments could not be loaded')));
                  }
                  if (!snap.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final docs = snap.data!.docs.toList()
                    ..sort((a, b) => _zaman(a.data()).compareTo(_zaman(b.data())));
                  if (docs.isEmpty) {
                    return Center(
                      child: Text(
                        tx('İlk yorumu sen yaz! 🍽️',
                            'Schrijf de eerste reactie! 🍽️',
                            'Write the first comment! 🍽️'),
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (context, i) {
                      final d = docs[i].data();
                      final benim = d['isim'] == _isim;
                      return ListTile(
                        dense: true,
                        title: Text(d['isim'] ?? '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary)),
                        subtitle: Text(d['yorum'] ?? '',
                            style: TextStyle(
                                fontSize: 14, color: AppColors.textPrimary)),
                        trailing: Text(
                          DateFormat('HH:mm').format(_zaman(d)),
                          style: TextStyle(
                              fontSize: 11, color: AppColors.textSecondary),
                        ),
                        onLongPress:
                            benim ? null : () => _sikayetEt(docs[i].id, d),
                      );
                    },
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLength: 300,
                        minLines: 1,
                        maxLines: 3,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _gonder(),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: tx('Yemek nasıldı?', 'Hoe was het eten?',
                              'How was the food?'),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: _gonderiliyor ? null : _gonder,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
