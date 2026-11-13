import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_colors.dart';
import '../l10n/dil.dart';

class SohbetScreen extends StatefulWidget {
  @override
  _SohbetScreenState createState() => _SohbetScreenState();
}

class _SohbetScreenState extends State<SohbetScreen> {
  final _controller = TextEditingController();
  String? _isim;

  @override
  void initState() {
    super.initState();
    _isimYukle();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _isimYukle() async {
    final prefs = await SharedPreferences.getInstance();
    final isim = prefs.getString('sohbet_isim');
    if (isim == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _isimSor());
    } else {
      setState(() => _isim = isim);
    }
  }

  Future<void> _sikayetEt(String mesajId, Map<String, dynamic> d) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tx('Mesajı şikayet et', 'Bericht melden', 'Report message', 'Nachricht melden')),
        content: Text(tx(
            'Bu mesaj uygunsuz içerik barındırıyor mu?',
            'Bevat dit bericht ongepaste inhoud?',
            'Does this message contain inappropriate content?', 'Enthält diese Nachricht unangemessene Inhalte?')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(tx('Vazgeç', 'Annuleren', 'Cancel', 'Abbrechen'))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(tx('Şikayet et', 'Melden', 'Report', 'Melden'))),
        ],
      ),
    );
    if (onay != true) return;

    await FirebaseFirestore.instance.collection('sikayetler').add({
      'mesajId': mesajId,
      'mesaj': d['mesaj'],
      'isim': d['isim'],
      'zaman': FieldValue.serverTimestamp(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(tx(
                'Şikayetiniz alındı, teşekkürler.',
                'Bedankt, je melding is ontvangen.',
                'Thanks, your report has been received.', 'Danke, deine Meldung ist eingegangen.'))),
      );
    }
  }

  Future<void> _isimSor({bool degistir = false}) async {
    final c = TextEditingController(text: degistir ? (_isim ?? '') : '');
    await showDialog(
      context: context,
      barrierDismissible: degistir,
      builder: (_) => AlertDialog(
        title: Text(tx('Takma adın?', 'Je bijnaam?', 'Your nickname?', 'Dein Spitzname?')),
        content: TextField(
          controller: c,
          maxLength: 15,
          decoration: InputDecoration(
              hintText: tx('Örn: Ahmet', 'Bijv. Sanne', 'E.g. Alex', 'Z. B. Lena')),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (c.text.trim().isEmpty) return;
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('sohbet_isim', c.text.trim());
              setState(() => _isim = c.text.trim());
              Navigator.pop(context);
            },
            child: Text(tx('Tamam', 'OK', 'OK', 'OK')),
          ),
        ],
      ),
    );
  }

  Future<void> _gonder() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isim == null) return;
    _controller.clear();
    await FirebaseFirestore.instance.collection('sohbet').add({
      'mesaj': text,
      'isim': _isim,
      'zaman': FieldValue.serverTimestamp(),
    });
  }

  // Mesaj zamanı (sunucu zamanı henüz gelmediyse şimdi kabul edilir)
  DateTime _zaman(Map<String, dynamic> d) {
    final z = d['zaman'];
    if (z is Timestamp) return z.toDate();
    return DateTime.now();
  }

  bool _ayniGun(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _gunBasligi(DateTime t) {
    final simdi = DateTime.now();
    if (_ayniGun(t, simdi)) return tx('Bugün', 'Vandaag', 'Today', 'Heute');
    if (_ayniGun(t, simdi.subtract(Duration(days: 1)))) {
      return tx('Dün', 'Gisteren', 'Yesterday', 'Gestern');
    }
    final bugun = DateTime(simdi.year, simdi.month, simdi.day);
    final gun = DateTime(t.year, t.month, t.day);
    if (bugun.difference(gun).inDays < 7) {
      return DateFormat('EEEE', Dil.locale).format(t);
    }
    if (t.year == simdi.year) {
      return DateFormat('d MMMM, EEEE', Dil.locale).format(t);
    }
    return DateFormat('d MMMM y', Dil.locale).format(t);
  }

  String _tamZaman(DateTime t) =>
      DateFormat('d MMMM y, EEEE · HH:mm', Dil.locale).format(t);

  // Her takma ada sabit bir renk
  static const _isimRenkleri = [
    Color(0xFF1E88E5), Color(0xFF43A047), Color(0xFF8E24AA), Color(0xFFF4511E),
    Color(0xFF00897B), Color(0xFF6D4C41), Color(0xFF3949AB), Color(0xFFD81B60),
  ];

  Color _isimRengi(String isim) {
    var h = 0;
    for (final c in isim.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return _isimRenkleri[h % _isimRenkleri.length];
  }

  // Mesaja dokununca: tam tarih/saat, kopyala, şikayet et
  void _mesajDetay(String mesajId, Map<String, dynamic> d, DateTime zaman,
      bool benim, bool gonderiliyor) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text(d['isim'] ?? ''),
              subtitle: Text(gonderiliyor
                  ? tx('Gönderiliyor...', 'Wordt verzonden...', 'Sending...', 'Wird gesendet …')
                  : _tamZaman(zaman)),
            ),
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.copy),
              title: Text(tx('Mesajı kopyala', 'Bericht kopiëren',
                  'Copy message', 'Nachricht kopieren')),
              onTap: () {
                Clipboard.setData(ClipboardData(text: d['mesaj'] ?? ''));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(tx('Kopyalandı', 'Gekopieerd', 'Copied', 'Kopiert'))));
              },
            ),
            if (!benim)
              ListTile(
                leading: Icon(Icons.flag_outlined, color: AppColors.error),
                title: Text(tx('Şikayet et', 'Melden', 'Report', 'Melden')),
                onTap: () {
                  Navigator.pop(ctx);
                  _sikayetEt(mesajId, d);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _gunEtiketi(String metin) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            metin,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tx('SOHBET ODASI', 'STUDENTENCHAT', 'STUDENT CHAT', 'STUDI-CHAT')),
        actions: [
          IconButton(
            tooltip: tx('Takma adı değiştir', 'Bijnaam wijzigen',
                'Change nickname', 'Spitznamen ändern'),
            icon: Icon(Icons.edit_outlined),
            onPressed: () => _isimSor(degistir: true),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sohbet')
                  .orderBy('zaman', descending: true)
                  .limit(50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return Center(
                      child: Text(tx('İlk mesajı sen yaz! 👋',
                          'Schrijf het eerste bericht! 👋',
                          'Write the first message! 👋', 'Schreib die erste Nachricht! 👋')));
                }
                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i].data() as Map<String, dynamic>;
                    final benim = d['isim'] == _isim;
                    final zaman = _zaman(d);

                    // Liste ters (en yeni altta). Bir sonraki eleman daha eski mesajdır;
                    // gün değiştiyse bu mesajın üstüne gün etiketi koy.
                    bool gunBasligiGoster = true;
                    bool ayniKisi = false;
                    if (i + 1 < docs.length) {
                      final od = docs[i + 1].data() as Map<String, dynamic>;
                      gunBasligiGoster = !_ayniGun(_zaman(od), zaman);
                      ayniKisi = !gunBasligiGoster && od['isim'] == d['isim'];
                    }
                    final gonderiliyor = docs[i].metadata.hasPendingWrites;

                    final saat = DateFormat('HH:mm').format(zaman);

                    final balon = Align(
                      alignment:
                          benim ? Alignment.centerRight : Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => _mesajDetay(
                            docs[i].id, d, zaman, benim, gonderiliyor),
                        onLongPress:
                            benim ? null : () => _sikayetEt(docs[i].id, d),
                        child: Container(
                          margin: EdgeInsets.only(
                              top: ayniKisi ? 1 : 6, bottom: 1),
                          padding: EdgeInsets.fromLTRB(10, 8, 10, 6),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: benim ? AppColors.primary : AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!benim && !ayniKisi)
                                Text(d['isim'] ?? '',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: _isimRengi(d['isim'] ?? ''))),
                              Text(d['mesaj'] ?? '',
                                  style: TextStyle(
                                      color: benim
                                          ? Colors.white
                                          : AppColors.textPrimary)),
                              SizedBox(height: 3),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      saat,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: benim
                                            ? Colors.white70
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                    if (benim) ...[
                                      SizedBox(width: 3),
                                      Icon(
                                        gonderiliyor
                                            ? Icons.schedule
                                            : Icons.done,
                                        size: 12,
                                        color: Colors.white70,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    if (!gunBasligiGoster) return balon;
                    return Column(
                      children: [
                        _gunEtiketi(_gunBasligi(zaman)),
                        balon,
                      ],
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLength: 200,
                      onSubmitted: (_) => _gonder(),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: tx('Mesaj yaz...', 'Schrijf een bericht...',
                            'Write a message...', 'Nachricht schreiben …'),
                        filled: true,
                        fillColor: Colors.white,
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
                      onPressed: _gonder,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
