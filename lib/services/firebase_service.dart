import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/university_config.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mekanları getir
  Stream<QuerySnapshot> getMekanlar() {
    return _firestore
        .collection(UniversityConfig.mekanlarCollection)
        .where('aktif', isEqualTo: true)
        .snapshots();
  }

  // Yemekleri getir
  Stream<QuerySnapshot> getYemekler() {
    return _firestore
        .collection(UniversityConfig.yemeklerCollection)
        .snapshots();
  }

  // Duyuru ve Etkinlikleri getir
  Stream<QuerySnapshot> getDuyurular({String? tip}) {
    Query query = _firestore
        .collection(UniversityConfig.duyurularCollection)
        .where('aktif', isEqualTo: true);
    // .orderBy('tarih', descending: true);

    if (tip != null) {
      query = query.where('tip', isEqualTo: tip);
    }

    return query.snapshots();
  }
}