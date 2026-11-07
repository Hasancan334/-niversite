import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_colors.dart';

class HaberSlider extends StatefulWidget {
  final VoidCallback onTap;
  HaberSlider({required this.onTap});
  @override
  _HaberSliderState createState() => _HaberSliderState();
}

class _HaberSliderState extends State<HaberSlider> {
  final _pc = PageController();
  Timer? _timer;
  int _count = 0;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 4), (_) {
      if (_count < 2 || !_pc.hasClients) return;
      _page = (_page + 1) % _count;
      _pc.animateToPage(_page,
          duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('duyuru_etkinlik')
          .where('aktif', isEqualTo: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SizedBox.shrink();
        }
        final docs = snapshot.data!.docs;
        _count = docs.length;
        return Container(
          height: 155,
          margin: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: PageView.builder(
            controller: _pc,
            itemCount: docs.length,
            onPageChanged: (i) => _page = i,
            itemBuilder: (context, i) {
              final d = docs[i].data() as Map<String, dynamic>;
              final etkinlik = d['tip'] == 'etkinlik';
              return InkWell(
                onTap: widget.onTap,
                child: Container(
                  margin: EdgeInsets.only(right: 6),
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      etkinlik ? AppColors.accent : AppColors.primary,
                      (etkinlik ? AppColors.accent : AppColors.primary)
                          .withOpacity(0.7),
                    ]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(etkinlik ? '🎉 ETKİNLİK' : '📢 DUYURU',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Flexible(child: Text(d['baslik'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold))),
                      SizedBox(height: 6),
                      Flexible(child: Text(d['icerik'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 14))),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}