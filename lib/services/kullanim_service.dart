import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class KullanimService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Bugün bu mekanda kullanım var mı?
  Future<bool> bugunKullanimVarMi(String mekanId, String userId) async {
    try {
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      var snapshot = await _firestore
          .collection('kullanim_gecmisi')
          .where('userId', isEqualTo: userId)
          .where('mekanId', isEqualTo: mekanId)
          .where('tarih', isEqualTo: today)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Kullanım kontrolü hatası: $e');
      return false;
    }
  }

  // Kullanım kaydet
  Future<bool> kullanimKaydet({
    required String mekanId,
    required String mekanAdi,
    required String userId,
    required String indirimOrani,
    required double latitude,
    required double longitude,
  }) async {
    try {
      DateTime now = DateTime.now();

      await _firestore.collection('kullanim_gecmisi').add({
        'userId': userId,
        'mekanId': mekanId,
        'mekanAdi': mekanAdi,
        'tarih': DateFormat('yyyy-MM-dd').format(now),
        'saat': DateFormat('HH:mm').format(now),
        'timestamp': FieldValue.serverTimestamp(),
        'konum': GeoPoint(latitude, longitude),
        'indirimOrani': indirimOrani,
      });

      return true;
    } catch (e) {
      print('Kullanım kaydetme hatası: $e');
      return false;
    }
  }

  // Mekan için toplam kullanım sayısı
  Future<int> mekanToplamKullanim(String mekanId, String ay) async {
    try {
      var snapshot = await _firestore
          .collection('kullanim_gecmisi')
          .where('mekanId', isEqualTo: mekanId)
          .where('tarih', isGreaterThanOrEqualTo: '$ay-01')
          .where('tarih', isLessThan: '$ay-32')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Toplam kullanım hatası: $e');
      return 0;
    }
  }
}