// UvA (Amsterdam) flavor'u: akademik takvim, kampüsler ve önemli linkler.
// Takvim her yıl güncellenmeli. Kaynak:
// https://student.uva.nl/en/academic-calendar/2026-2027
import 'package:flutter/material.dart';
import 'uva_data.dart';
import '../config/flavor.dart';

enum TakvimTur { periode, vrij, feestdag }

class TakvimItem {
  final String nl;
  final String en;
  final DateTime begin;
  final DateTime eind;
  final TakvimTur tur;
  const TakvimItem(this.nl, this.en, this.begin, this.eind, this.tur);
}

class Gebouw {
  final String naam;
  final String adres;
  final String nl;
  final String en;
  const Gebouw(this.naam, this.adres, this.nl, this.en);

  String get mapsUrl =>
      'https://www.google.com/maps/search/?api=1&query=' +
      Uri.encodeComponent('$naam, $adres, ${kKoeln ? 'Köln' : 'Amsterdam'}');
}

class Campus {
  final String naam;
  final String nl;
  final String en;
  final List<Gebouw> gebouwen;
  const Campus(this.naam, this.nl, this.en, this.gebouwen);
}

class UvaExtraData {
  static const String takvimUrl =
      'https://student.uva.nl/en/academic-calendar/2026-2027';
  static const String takvimJaar = '2026–2027';

  static final List<TakvimItem> takvim = [
    TakvimItem('Periode 1', 'Period 1', DateTime(2026, 8, 31),
        DateTime(2026, 10, 23), TakvimTur.periode),
    TakvimItem('Periode 2', 'Period 2', DateTime(2026, 10, 26),
        DateTime(2026, 12, 10), TakvimTur.periode),
    TakvimItem('Geen onderwijs of tentamens (kerst)',
        'No teaching or exams (Christmas)', DateTime(2026, 12, 19),
        DateTime(2027, 1, 3), TakvimTur.vrij),
    TakvimItem('Periode 3', 'Period 3', DateTime(2027, 1, 4),
        DateTime(2027, 1, 29), TakvimTur.periode),
    TakvimItem('Periode 4', 'Period 4', DateTime(2027, 2, 1),
        DateTime(2027, 3, 29), TakvimTur.periode),
    TakvimItem('Tweede Paasdag', 'Easter Monday', DateTime(2027, 3, 29),
        DateTime(2027, 3, 29), TakvimTur.feestdag),
    TakvimItem('Periode 5', 'Period 5', DateTime(2027, 3, 30),
        DateTime(2027, 5, 28), TakvimTur.periode),
    TakvimItem('Koningsdag', "King's Day", DateTime(2027, 4, 27),
        DateTime(2027, 4, 27), TakvimTur.feestdag),
    TakvimItem('Geen onderwijs of tentamens', 'No teaching or exams',
        DateTime(2027, 5, 3), DateTime(2027, 5, 7), TakvimTur.vrij),
    TakvimItem('Bevrijdingsdag', 'Liberation Day', DateTime(2027, 5, 5),
        DateTime(2027, 5, 5), TakvimTur.feestdag),
    TakvimItem('Hemelvaartsdag', 'Ascension Day', DateTime(2027, 5, 6),
        DateTime(2027, 5, 6), TakvimTur.feestdag),
    TakvimItem('Tweede Pinksterdag', 'Whit Monday', DateTime(2027, 5, 17),
        DateTime(2027, 5, 17), TakvimTur.feestdag),
    TakvimItem('Periode 6', 'Period 6', DateTime(2027, 5, 31),
        DateTime(2027, 6, 25), TakvimTur.periode),
    TakvimItem('Zomer en herkansingen', 'Summer and resits',
        DateTime(2027, 6, 26), DateTime(2027, 8, 29), TakvimTur.vrij),
  ];

  static const List<Campus> campussen = [
    Campus('Roeterseiland', 'Sociale wetenschappen, economie en recht.',
        'Social sciences, economics and law.', [
      Gebouw('Roeterseilandcomplex (REC)', 'Nieuwe Achtergracht 166',
          'Hoofdgebouwen A t/m V en de bibliotheek.',
          'Main buildings A to V and the library.'),
      Gebouw('CREA', 'Nieuwe Achtergracht 170',
          'Cultureel studentencentrum, ook voor evenementen.',
          'Student cultural centre, also used for events.'),
    ]),
    Campus('Science Park', 'Bètawetenschappen en informatica.',
        'Science and computer science.', [
      Gebouw('Science Park 904', 'Science Park 904',
          'Hoofdgebouw van de Faculteit der Natuurwetenschappen.',
          'Main building of the Faculty of Science.'),
    ]),
    Campus('Universiteitskwartier', 'Geesteswetenschappen, in de binnenstad.',
        'Humanities, in the city centre.', [
      Gebouw('Oudemanhuispoort', 'Oudemanhuispoort 4-6',
          'Historisch collegegebouw.', 'Historic lecture building.'),
      Gebouw('P.C. Hoofthuis', 'Spuistraat 134',
          'Colleges en werkplekken.', 'Lectures and study spaces.'),
      Gebouw('Bushuis', 'Kloveniersburgwal 48',
          'Colleges en kantoren.', 'Lectures and offices.'),
      Gebouw('Universiteitsbibliotheek Singel', 'Singel 425',
          'Centrale bibliotheek met studieplekken.',
          'Central library with study spaces.'),
      Gebouw('Allard Pierson', 'Oude Turfmarkt 127',
          'Museum en erfgoedcollecties van de UvA.',
          'UvA museum and heritage collections.'),
    ]),
    Campus('Amsterdam UMC', 'Geneeskunde.', 'Medicine.', [
      Gebouw('Amsterdam UMC, locatie AMC', 'Meibergdreef 9',
          'Faculteit der Geneeskunde.', 'Faculty of Medicine.'),
    ]),
    Campus('Zuidas', 'Tandheelkunde.', 'Dentistry.', [
      Gebouw('ACTA', 'Gustav Mahlerlaan 3004',
          'Academisch Centrum Tandheelkunde Amsterdam.',
          'Academic Centre for Dentistry Amsterdam.'),
    ]),
  ];

  static const List<UvaCategorie> belangrijkeLinks = [
    UvaCategorie('Studie & inschrijving', 'Study & enrolment', Icons.school, [
      UvaLink('student.uva.nl', 'Alle informatie voor UvA-studenten.',
          'All information for UvA students.', 'https://student.uva.nl/'),
      UvaLink('Studielink', 'Inschrijven en herinschrijven.',
          'Enrolment and re-enrolment.', 'https://www.studielink.nl/'),
      UvaLink('DUO', 'Studiefinanciering, collegegeldkrediet en ov-product.',
          'Student finance, tuition loan and student travel product.',
          'https://duo.nl/'),
    ]),
    UvaCategorie('Wonen', 'Housing', Icons.home_outlined, [
      UvaLink('DUWO', 'Studentenhuisvesting in Amsterdam.',
          'Student housing in Amsterdam.', 'https://www.duwo.nl/'),
      UvaLink('ROOM.nl', 'Studentenkamers via loting en inschrijving.',
          'Student rooms through registration and lottery.',
          'https://www.room.nl/'),
      UvaLink('Kamernet', 'Kamers en studio\'s van particulieren.',
          'Rooms and studios from private landlords.',
          'https://kamernet.nl/'),
    ]),
    UvaCategorie('Vervoer', 'Transport', Icons.directions_transit, [
      UvaLink('GVB', 'Tram, bus en metro in Amsterdam.',
          'Tram, bus and metro in Amsterdam.', 'https://www.gvb.nl/'),
      UvaLink('NS', 'Treinen in Nederland.', 'Trains in the Netherlands.',
          'https://www.ns.nl/'),
      UvaLink('9292', 'Reisplanner voor al het openbaar vervoer.',
          'Journey planner for all public transport.',
          'https://9292.nl/'),
    ]),
    UvaCategorie('Gemeente & overheid', 'City & government',
        Icons.account_balance, [
      UvaLink('Gemeente Amsterdam', 'Inschrijven op je adres en BSN.',
          'Register your address and get a BSN.',
          'https://www.amsterdam.nl/'),
      UvaLink('DigiD', 'Inloggen bij de overheid.',
          'Log in to government services.', 'https://www.digid.nl/'),
    ]),
    UvaCategorie('Nood & hulp', 'Emergency & help', Icons.local_hospital, [
      UvaLink('112', 'Alarmnummer bij spoed.', 'Emergency number.',
          'tel:112'),
      UvaLink('Politie (geen spoed)', '0900 8844', '0900 8844',
          'tel:09008844'),
    ]),
  ];
}
