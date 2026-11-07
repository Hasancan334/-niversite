import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_colors.dart';

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
        title: Text('Mesajı şikayet et'),
        content: Text('Bu mesaj uygunsuz içerik barındırıyor mu?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Vazgeç')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Şikayet et')),
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
        SnackBar(content: Text('Şikayetiniz alındı, teşekkürler.')),
      );
    }
  }
  Future<void> _isimSor() async {
    final c = TextEditingController();
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Takma adın?'),
        content: TextField(
          controller: c,
          maxLength: 15,
          decoration: InputDecoration(hintText: 'Örn: Ahmet'),
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
            child: Text('Tamam'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SOHBET ODASI')),
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
                  return Center(child: Text('İlk mesajı sen yaz! 👋'));
                }
                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i].data() as Map<String, dynamic>;
                    final benim = d['isim'] == _isim;
                    return Align(
                      alignment:
                      benim ? Alignment.centerRight : Alignment.centerLeft,
                      child: GestureDetector(
                        onLongPress: benim ? null : () => _sikayetEt(docs[i].id, d),

                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          padding: EdgeInsets.all(10),
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75),
                          decoration: BoxDecoration(
                            color: benim ? AppColors.primary : AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!benim)
                                Text(d['isim'] ?? '',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDark)),
                              Text(d['mesaj'] ?? '',
                                  style: TextStyle(
                                      color: benim
                                          ? Colors.white
                                          : AppColors.textPrimary)),
                            ],
                          ),
                        ),
                      ),
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
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Mesaj yaz...',
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