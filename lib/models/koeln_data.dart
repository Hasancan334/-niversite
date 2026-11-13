// Köln (Universität zu Köln) flavor'u için veriler.
// Metin alanları: önce yerel dil (Almanca), sonra İngilizce.
// Linkler ve takvim zamanla değişebilir; her dönem kontrol edin.
// Takvim kaynağı: https://studierende.uni-koeln.de/studienorganisation/termine/index_ger.html
import 'package:flutter/material.dart';
import 'uva_data.dart';
import 'uva_extra_data.dart';

class KoelnData {
  // ------------------------------------------------------------ Vereine
  static const List<UvaCategorie> vereine = [
    UvaCategorie('International', 'International', Icons.flight_takeoff, [
      UvaLink('ESN Köln', 'Erasmus Student Network: Events und Hilfe für internationale Studierende.',
          'Erasmus Student Network: events and support for international students.',
          'https://koeln.esngermany.de/'),
      UvaLink('AIESEC Köln', 'Studentische Organisation für Praktika und Ehrenamt im Ausland.',
          'Student organisation for internships and volunteering abroad.',
          'https://www.aiesec-koeln.de/'),
      UvaLink('Internationale Studierendenvereinigungen',
          'Übersicht der Universität zu internationalen Vereinigungen.',
          "The university's overview of international student associations.",
          'https://www.uni-koeln.de/en/international/study-in-cologne/services-for-enrolled-international-students/international-student-associations'),
    ]),
    UvaCategorie('Debatte & Engagement', 'Debate & involvement', Icons.lightbulb_outline, [
      UvaLink('Debattierclub Köln', 'Debattieren lernen, Einsteigerabende zum Semesterstart.',
          'Learn to debate, beginner evenings at the start of each semester.',
          'https://debattierclubkoeln.com/'),
      UvaLink('AStA Uni Köln', 'Allgemeiner Studierendenausschuss: Vertretung und Beratung.',
          'General Students\' Committee: representation and advice.',
          'https://www.asta.uni-koeln.de/'),
      UvaLink('Hochschulgruppen', 'Liste der eingetragenen Hochschulgruppen der Universität.',
          'List of registered student groups at the university.',
          'https://studierende.uni-koeln.de/mitbestimmung__engagement/hochschulgruppen/index_ger.html'),
      UvaLink('Studentische Initiativen', 'Initiativen rund um Studium und Beruf.',
          'Initiatives around studies and careers.',
          'https://verwaltung.uni-koeln.de/abteilung21/content/studieninteressierte/wo_finde_ich_weitere_angebote/studien__und_berufswahl/studienbegleitende_berufsqualifikation/studentische_initiativen/index_ger.html'),
    ]),
  ];

  // ------------------------------------------------------------ Studium
  static const List<UvaCategorie> quellen = [
    UvaCategorie('Studium', 'Studying', Icons.school, [
      UvaLink('KLIPS 2.0', 'Kurse belegen, Stundenplan und Prüfungen.',
          'Course registration, timetable and exams.', 'https://klips2.uni-koeln.de/'),
      UvaLink('ILIAS', 'Lernplattform: Folien und Kursmaterial.',
          'Learning platform: slides and course materials.', 'https://www.ilias.uni-koeln.de/'),
      UvaLink('KLIPS-Hilfe', 'Anleitungen zu KLIPS 2.0.', 'Help pages for KLIPS 2.0.',
          'https://klips2-support.uni-koeln.de/'),
      UvaLink('Studierendenportal', 'Infos, Termine und Fristen für Studierende.',
          'Information, dates and deadlines for students.',
          'https://studierende.uni-koeln.de/'),
    ]),
    UvaCategorie('Bibliothek', 'Library', Icons.menu_book, [
      UvaLink('Universitäts- und Stadtbibliothek (USB)', 'Katalog, Ausleihe und Lernplätze.',
          'Catalogue, loans and study spaces.', 'https://www.ub.uni-koeln.de/'),
    ]),
  ];

  // ------------------------------------------------------------ Kalender
  static const String kalenderUrl =
      'https://studierende.uni-koeln.de/studienorganisation/termine/index_ger.html';
  static const String kalenderJahr = '2026/27';

  static final List<TakvimItem> kalender = [
    TakvimItem('Tag der Deutschen Einheit', 'German Unity Day', DateTime(2026, 10, 3),
        DateTime(2026, 10, 3), TakvimTur.feestdag),
    TakvimItem('Vorlesungszeit Wintersemester', 'Winter semester lectures',
        DateTime(2026, 10, 12), DateTime(2027, 2, 5), TakvimTur.periode),
    TakvimItem('Allerheiligen', "All Saints' Day", DateTime(2026, 11, 1),
        DateTime(2026, 11, 1), TakvimTur.feestdag),
    TakvimItem('Weihnachtspause (keine Vorlesungen)', 'Christmas break (no lectures)',
        DateTime(2026, 12, 23), DateTime(2027, 1, 6), TakvimTur.vrij),
    TakvimItem('Weiberfastnacht (Karneval)', 'Weiberfastnacht (Carnival)',
        DateTime(2027, 2, 4), DateTime(2027, 2, 4), TakvimTur.feestdag),
    TakvimItem('Vorlesungsfreie Zeit', 'Semester break', DateTime(2027, 2, 6),
        DateTime(2027, 4, 4), TakvimTur.vrij),
    TakvimItem('Rosenmontag (Karneval)', 'Rose Monday (Carnival)', DateTime(2027, 2, 8),
        DateTime(2027, 2, 8), TakvimTur.feestdag),
    TakvimItem('Karfreitag', 'Good Friday', DateTime(2027, 3, 26), DateTime(2027, 3, 26),
        TakvimTur.feestdag),
    TakvimItem('Ostermontag', 'Easter Monday', DateTime(2027, 3, 29),
        DateTime(2027, 3, 29), TakvimTur.feestdag),
    TakvimItem('Vorlesungszeit Sommersemester', 'Summer semester lectures',
        DateTime(2027, 4, 5), DateTime(2027, 7, 16), TakvimTur.periode),
    TakvimItem('Tag der Arbeit', 'Labour Day', DateTime(2027, 5, 1), DateTime(2027, 5, 1),
        TakvimTur.feestdag),
    TakvimItem('Christi Himmelfahrt', 'Ascension Day', DateTime(2027, 5, 6),
        DateTime(2027, 5, 6), TakvimTur.feestdag),
    TakvimItem('Pfingstmontag', 'Whit Monday', DateTime(2027, 5, 17),
        DateTime(2027, 5, 17), TakvimTur.feestdag),
    TakvimItem('Fronleichnam', 'Corpus Christi', DateTime(2027, 5, 27),
        DateTime(2027, 5, 27), TakvimTur.feestdag),
    TakvimItem('Vorlesungsfreie Zeit', 'Semester break', DateTime(2027, 7, 17),
        DateTime(2027, 9, 30), TakvimTur.vrij),
  ];

  // ------------------------------------------------------------ Campus
  static const List<Campus> campusse = [
    Campus('Hauptcampus', 'Rund um den Albertus-Magnus-Platz.',
        'Around Albertus-Magnus-Platz.', [
      Gebouw('Hauptgebäude', 'Albertus-Magnus-Platz',
          'Verwaltung, Hörsäle und Aula.', 'Administration, lecture halls and the Aula.'),
      Gebouw('Hörsaalgebäude', 'Albertus-Magnus-Platz',
          'Große Hörsäle (A1, A2 …).', 'Large lecture halls (A1, A2 …).'),
      Gebouw('Philosophikum', 'Albertus-Magnus-Platz',
          'Philosophische Fakultät.', 'Faculty of Arts and Humanities.'),
      Gebouw('Seminargebäude', 'Universitätsstraße 37',
          'Seminarräume.', 'Seminar rooms.'),
      Gebouw('Universitäts- und Stadtbibliothek (USB)', 'Universitätsstraße 33',
          'Zentrale Bibliothek mit Lernplätzen.', 'Central library with study spaces.'),
    ]),
    Campus('Naturwissenschaften', 'Rund um Zülpicher Straße und Weyertal.',
        'Around Zülpicher Straße and Weyertal.', [
      Gebouw('Physikalische Institute', 'Zülpicher Straße 77',
          'Physik.', 'Physics.'),
      Gebouw('Mathematisches Institut', 'Weyertal 86-90',
          'Mathematik und Informatik.', 'Mathematics and computer science.'),
      Gebouw('Chemische Institute', 'Greinstraße 4-6',
          'Chemie.', 'Chemistry.'),
    ]),
    Campus('Humanwissenschaften', 'Lindenthal.', 'Lindenthal.', [
      Gebouw('Humanwissenschaftliche Fakultät', 'Gronewaldstraße 2',
          'Lehramt, Psychologie und Heilpädagogik.',
          'Teacher training, psychology and special education.'),
    ]),
    Campus('Uniklinik', 'Medizinische Fakultät.', 'Faculty of Medicine.', [
      Gebouw('Uniklinik Köln', 'Kerpener Straße 62',
          'Universitätsklinikum und Medizin.', 'University hospital and medicine.'),
    ]),
  ];

  // ------------------------------------------------------------ Mensa
  // Speisepläne veröffentlicht das Kölner Studierendenwerk (KStW).
  static const String mensaUrl =
      'https://www.kstw.de/gastronomie/mensen-bistros-und-kaffeebars/';
  static const String speiseplanUrl = 'https://koeln.my-mensa.de/';

  static const List<Gebouw> mensen = [
    Gebouw('Mensa Zülpicher Straße', 'Zülpicher Straße 70',
        'Hauptmensa am Hauptcampus. Mo–Fr mittags.',
        'Main canteen near the main campus. Mon–Fri at lunchtime.'),
    Gebouw('Mensa Lindenthal', 'Robert-Koch-Straße 10',
        'Mensa in Lindenthal. Mo–Fr mittags.',
        'Canteen in Lindenthal. Mon–Fri at lunchtime.'),
  ];

  // ------------------------------------------------------------ Links
  static const List<UvaCategorie> links = [
    UvaCategorie('Studium & Verwaltung', 'Study & administration', Icons.school, [
      UvaLink('Studierendenportal', 'Termine, Fristen, Rückmeldung.',
          'Dates, deadlines, re-registration.', 'https://studierende.uni-koeln.de/'),
      UvaLink('KLIPS 2.0', 'Kurse, Stundenplan, Prüfungen.', 'Courses, timetable, exams.',
          'https://klips2.uni-koeln.de/'),
    ]),
    UvaCategorie('Wohnen & Essen', 'Housing & food', Icons.home_outlined, [
      UvaLink('Kölner Studierendenwerk', 'Wohnheime, Mensen, BAföG und Beratung.',
          'Student halls, canteens, BAföG and counselling.', 'https://www.kstw.de/'),
      UvaLink('WG-Gesucht', 'WG-Zimmer und Wohnungen.', 'Shared flats and apartments.',
          'https://www.wg-gesucht.de/'),
    ]),
    UvaCategorie('Mobilität', 'Transport', Icons.directions_transit, [
      UvaLink('KVB', 'Bus und Bahn in Köln.', 'Buses and trams in Cologne.',
          'https://www.kvb.de/'),
      UvaLink('Deutsche Bahn', 'Züge in Deutschland.', 'Trains in Germany.',
          'https://www.bahn.de/'),
    ]),
    UvaCategorie('Stadt & Behörden', 'City & authorities', Icons.account_balance, [
      UvaLink('Stadt Köln', 'Wohnsitz anmelden und Bürgerdienste.',
          'Register your address and city services.', 'https://www.stadt-koeln.de/'),
    ]),
    UvaCategorie('Notfall & Hilfe', 'Emergency & help', Icons.local_hospital, [
      UvaLink('112', 'Feuerwehr und Rettungsdienst.', 'Fire brigade and ambulance.', 'tel:112'),
      UvaLink('110', 'Polizei.', 'Police.', 'tel:110'),
      UvaLink('116 117', 'Ärztlicher Bereitschaftsdienst (nicht lebensbedrohlich).',
          'Out-of-hours doctor (non-life-threatening).', 'tel:116117'),
    ]),
  ];
}
