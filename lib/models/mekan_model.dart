class MekanModel {
  final String id;
  final String isim;
  final String kategori;
  final String adres;
  final String indirimOrani;
  final String indirimKodu;
  final String aciklama;
  final String fotograf;
  final String telefon;
  final String googleMapsLink;
  final bool aktif;
  final double? latitude;   // YENİ!
  final double? longitude;  // YENİ!

  MekanModel({
    required this.id,
    required this.isim,
    required this.kategori,
    required this.adres,
    required this.indirimOrani,
    required this.indirimKodu,
    required this.aciklama,
    required this.fotograf,
    required this.telefon,
    required this.googleMapsLink,
    required this.aktif,
    this.latitude,
    this.longitude,
  });

  factory MekanModel.fromFirestore(Map<String, dynamic> data, String id) {
    return MekanModel(
      id: id,
      isim: data['isim'] ?? '',
      kategori: data['kategori'] ?? '',
      adres: data['adres'] ?? '',
      indirimOrani: data['indirimOrani'] ?? '',
      indirimKodu: data['indirimKodu'] ?? '',
      aciklama: data['aciklama'] ?? '',
      fotograf: data['fotograf'] ?? '',
      telefon: data['telefon'] ?? '',
      googleMapsLink: data['googleMapsLink'] ?? '',
      aktif: data['aktif'] ?? true,
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
    );
  }
}