// UvA (Amsterdam) flavor'u için kulüp ve kaynak verileri.
// Kaynak: student.uva.nl (resmi UvA öğrenci sayfaları). Linkleri düzenli kontrol edin.
import 'package:flutter/material.dart';

class UvaLink {
  final String naam;
  final String nl;
  final String en;
  final String url;
  const UvaLink(this.naam, this.nl, this.en, this.url);
}

class UvaCategorie {
  final String nl;
  final String en;
  final IconData icon;
  final List<UvaLink> items;
  const UvaCategorie(this.nl, this.en, this.icon, this.items);
}

class UvaData {
  static const List<UvaCategorie> verenigingen = [
    UvaCategorie("WhatsApp-groepen", "WhatsApp groups", Icons.chat, [
      UvaLink("ESN Amsterdam (WhatsApp)", "Groep voor Erasmus- en internationale studenten, najaar 2026.", "Group for Erasmus and international students, fall 2026.", "https://chat.whatsapp.com/KDsBq6apbUd2uhwo9MxN54"),
      UvaLink("Boosted Gryffins", "Gaming- en e-sportscommunity voor studenten van UvA, VU en HvA.", "Gaming and esports community for UvA, VU and HvA students.", "https://chat.whatsapp.com/GvhKPpadjhLErqn27jhGw1"),
      UvaLink("ASVA – UvA Sociale Wetenschappen", "ASVA-facultaire groep over studentenrechten en problemen op de faculteit.", "ASVA faculty group on student rights and faculty issues.", "https://chat.whatsapp.com/FDTQoDiRd8Q7iApbMKmPdh"),
      UvaLink("ASVA – UvA Geesteswetenschappen", "ASVA-facultaire groep over studentenrechten en problemen op de faculteit.", "ASVA faculty group on student rights and faculty issues.", "https://chat.whatsapp.com/ChvM53GUBugAz2VsvOhAsE"),
      UvaLink("ASVA – UvA Bètawetenschappen", "ASVA-facultaire groep over studentenrechten en problemen op de faculteit.", "ASVA faculty group on student rights and faculty issues.", "https://chat.whatsapp.com/EeuyGruQEts3tpfJhrXvCs"),
    ]),
    UvaCategorie("Debat, ondernemen & studie", "Debate, business & academic", Icons.lightbulb_outline, [
      UvaLink("Bonaparte", "Amsterdamse studentendebatvereniging.", "Amsterdam student debating association.", "https://www.asdvbonaparte.nl/"),
      UvaLink("ASIF Ventures", "Venture capital-fonds dat investeert in startups van studenten.", "Venture capital fund investing in student-founded startups.", "https://www.asif.ventures/"),
      UvaLink("180 Degrees Consulting Amsterdam", "Studententeams adviseren organisaties met een maatschappelijk doel.", "Student teams advise social impact organisations.", "https://amsterdam05.wixsite.com/180dc-amsterdam"),
      UvaLink("Enactus UvA", "Ondernemende oplossingen voor sociale, economische en ecologische problemen.", "Entrepreneurial solutions for social, economic and ecological problems.", "https://www.enactusatuva.com/"),
      UvaLink("IFMSA", "Internationale geneeskundestudenten gericht op wereldwijde gezondheid.", "International medical students focused on global health.", "https://www.ifmsa.nl/"),
      UvaLink("UNISCA", "Organiseert Model United Nations samen met de UvA.", "Organises Model United Nations with the UvA.", "https://www.uniscamun.org/"),
    ]),
    UvaCategorie("Cultuur & afkomst", "Ethnic & cultural", Icons.public, [
      UvaLink("ABBA", "Voor mensen met roots rond de Adriatische, Baltische, Zwarte en Azovzee.", "For people with roots around the Adriatic, Baltic, Black and Azov Seas.", "https://www.facebook.com/abbastudentassociation/"),
      UvaLink("ASAA", "Arabische cultuur en gemeenschap, open voor iedereen.", "Arab culture and community, open to all.", "https://www.asaamsterdam.nl/"),
      UvaLink("AtlasBridges", "Internationale non-profit met centra in Amsterdam en Marokko.", "International non-profit with centres in Amsterdam and Morocco.", "https://www.atlasbridges.nl/"),
      UvaLink("ASN", "Gemeenschap voor Aziatische studenten en wie geïnteresseerd is in Azië.", "Community for Asian students and those interested in Asia.", "https://asn-online.nl/"),
      UvaLink("BASA", "Veilige plek voor zwarte en Afrikaanse studenten.", "Safe space for Black and African students.", "https://www.instagram.com/basa_uva/"),
      UvaLink("EESA", "Oost-Europese cultuur en geschiedenis delen.", "Shares Eastern European culture and history.", "https://www.instagram.com/eesa.ams/"),
      UvaLink("IJAR Amsterdam", "Joodse studenten- en jongerenvereniging.", "Jewish student and youth association.", "https://www.facebook.com/ijardujs/"),
      UvaLink("Hvanti", "Netwerk voor Caribisch-Nederlandse studenten.", "Network for Dutch-Caribbean students.", "https://www.amsterdamuas.com/study/information-for/caribbean-students"),
      UvaLink("MENA Student Association", "Inclusief beeld van de cultuur van het Midden-Oosten en Noord-Afrika.", "Promotes an inclusive view of Middle Eastern and North African culture.", "https://www.menasa.nl/"),
    ]),
    UvaCategorie("Gendergelijkheid", "Gender equality", Icons.diversity_3, [
      UvaLink("HeforShe X UvA", "Onderdeel van de VN-beweging voor gendergelijkheid.", "Part of the UN gender equality movement.", "https://www.instagram.com/hfs.uva/"),
    ]),
    UvaCategorie("Internationaal", "International", Icons.flight_takeoff, [
      UvaLink("AIESEC", "Studentenorganisatie voor stages en vrijwilligerswerk in het buitenland.", "Student-run organisation for internships and volunteering abroad.", "https://aiesec.nl/"),
      UvaLink("ESN Amsterdam", "Helpt internationale studenten het meeste uit hun verblijf te halen.", "Helps international students get the most from their stay.", "https://esn-amsterdam.nl/"),
      UvaLink("HOST", "Christelijke groep voor internationale studenten en onderzoekers.", "Christian-organised group for international students and researchers.", "https://wearehost.nl/amsterdam/"),
      UvaLink("SIB", "Internationaal georiënteerde vereniging, open voor alle studierichtingen.", "Internationally oriented association open to all fields of study.", "https://www.sibamsterdam.nl/"),
    ]),
    UvaCategorie("Religie & levensbeschouwing", "Religion & spirituality", Icons.self_improvement, [
      UvaLink("C.S.F.R. Amsterdam", "Gereformeerde christelijke studentenvereniging.", "Reformed Christian student association.", "https://www.csframsterdam.nl/"),
      UvaLink("HSFN", "Hindoestudenten, met een afdeling in Amsterdam.", "Serves Hindu students, with an Amsterdam branch.", "https://hsfn.nl/"),
      UvaLink("Ichthus Amsterdam", "Evangelische gemeenschap rond bijbelstudie en vriendschap.", "Evangelical community centred on Bible study and friendship.", "https://ichthusamsterdam.nl/"),
      UvaLink("MUSA", "Islamitische studentenvereniging van Amsterdam.", "Muslim University Students of Amsterdam, the UvA Islamic student association.", "https://svmusa.nl/"),
      UvaLink("Navigators (NSA)", "Grote christelijke studentenvereniging.", "Large Christian student association.", "https://www.nsamsterdam.nl/"),
      UvaLink("Student Meditation", "Meditatie voor het welzijn van UvA-studenten en medewerkers.", "Meditation for the well-being of UvA students and staff.", "https://studentmeditation.nl/"),
      UvaLink("Thomas Aquinas", "Rooms-katholieke studentenvereniging.", "Roman Catholic student association.", "http://thomasaquinas.nl/home.htm"),
    ]),
    UvaCategorie("Theater, kunst & muziek", "Theatre, art & music", Icons.theater_comedy, [
      UvaLink("ASPK", "Koor en toneelgroep die operettes opvoert.", "Choir and theatre group producing operettas.", "http://hetaspk.nl/"),
      UvaLink("Particolarte", "Kunst- en cultuurvereniging met open podia en een maandelijks magazine.", "Art and culture association with open stages and a monthly magazine.", "https://www.particolarte.nl/"),
      UvaLink("Student Theatre Amsterdam (STA!)", "Toneelvereniging met studentenproducties.", "Theatre association staging student productions.", "https://www.sta-toneel.nl/"),
      UvaLink("Studentenkoor Amsterdam (SKA)", "Koor voor studenten en alumni.", "Choir for students and alumni.", "http://www.studentenkooramsterdam.nl/"),
      UvaLink("UvA Orkest Sweelinck", "Symfonieorkest, opgericht in 1878.", "Symphony orchestra founded in 1878.", "http://www.sweelinckorkest.nl/"),
    ]),
    UvaCategorie("Toegankelijkheid", "Accessibility", Icons.accessible, [
      UvaLink("UvA IDEAs", "Platform van studenten met een beperking voor een toegankelijke, inclusieve UvA.", "Platform run by students with disabilities for an accessible, inclusive UvA.", "https://student.uva.nl/en/information/uva-ideas"),
    ]),
    UvaCategorie("Studentensport", "Student sports", Icons.sports_soccer, [
      UvaLink("Studentensport Amsterdam (SSA)", "Overzicht van alle studentensportverenigingen in Amsterdam.", "Overview of all student sports associations in Amsterdam.", "https://www.studentensport.amsterdam/sportaanbod/"),
      UvaLink("Sporten bij het USC", "Sporten bij het Universitair Sportcentrum.", "Exercise at the university sports centre (USC).", "https://student.uva.nl/en/information/exercise-at-usc"),
      UvaLink("Aquila (atletiek)", "Atletiek", "Athletics", "https://www.asavaquila.nl/nl/"),
      UvaLink("US Badminton", "Badminton", "Badminton", "https://www.us-badminton.nl/"),
      UvaLink("BC Schrobbelaar", "Basketbal", "Basketball", "https://www.bcschrobbelaar.nl/"),
      UvaLink("DERM", "Boardsports", "Board sports", "https://www.derm.nl/"),
      UvaLink("SDV Amsterdance", "Dans", "Dance", "https://sdvamsterdance.nl/"),
      UvaLink("Dodgeball Club Amsterdam", "Trefbal (dodgeball)", "Dodgeball", "https://dodgeballclubamsterdam.com/"),
      UvaLink("HORS", "Paardrijden", "Equestrian", "https://www.asrhors.nl/"),
      UvaLink("ASSV Esprit", "Schermen", "Fencing", "https://www.assvesprit.nl/"),
      UvaLink("Student Football League", "Voetbal", "Football", "https://www.sfleague.nl/"),
      UvaLink("STAH", "Turnen", "Gymnastics", "https://www.stahamsterdam.nl/"),
      UvaLink("US Handbal", "Handbal", "Handball", "https://www.ushandbal.nl/"),
      UvaLink("Thor", "IJshockey", "Ice hockey", "https://thoramsterdam.nl/"),
      UvaLink("SKV Amsterdam", "Korfbal", "Korfball", "https://skvamsterdam.nl/"),
      UvaLink("Amsterdam Lions Lacrosse", "Lacrosse", "Lacrosse", "https://www.amsterdamlacrosse.nl/"),
      UvaLink("ASAC", "Bergsport en klimmen", "Mountaineering", "https://asac.nl/"),
      UvaLink("AASR Skøll", "Roeien", "Rowing", "https://skoll.nl"),
      UvaLink("Nereus", "Roeien", "Rowing", "https://www.nereus.nl/"),
      UvaLink("RSVU Okeanos", "Roeien", "Rowing", "https://www.okeanos.nl/nl"),
      UvaLink("Ascrum", "Rugby", "Rugby", "https://ascrum.com/vereniging"),
      UvaLink("Orionis", "Zeilen", "Sailing", "https://orionis.nl/"),
      UvaLink("SKITS", "Schaatsen en wielrennen", "Skating and cycling", "https://www.skits.nl/"),
      UvaLink("SCHIET Squash", "Squash", "Squash", "https://www.schietsquash.nl/"),
      UvaLink("ASZV SPONS", "Zwemmen", "Swimming", "https://aszvspons.nl/"),
      UvaLink("Chip & Charge", "Tennis en padel", "Tennis and padel", "https://www.chipencharge.nl/"),
      UvaLink("Ultimate NUTS", "Ultimate frisbee", "Ultimate frisbee", "https://ultimatenuts.nl/"),
      UvaLink("Amsterdam Beach Club", "Beachvolleybal", "Beach volleyball", "https://amsterdam-beach-club.nl/nl"),
      UvaLink("UVO Amsterdam", "Volleybal", "Volleyball", "https://www.uvo-amsterdam.nl/"),
      UvaLink("SVU Volleybal", "Volleybal", "Volleyball", "https://www.svuvolleybal.nl/"),
      UvaLink("JAWS", "Waterpolo", "Water polo", "https://jawswaterpolo.nl/"),
    ]),
  ];

  static const List<UvaCategorie> bronnen = [
    UvaCategorie("Canvas & studie", "Canvas & studying", Icons.school, [
      UvaLink("Canvas (cursusmateriaal, opdrachten, toetsen)", "Canvas (cursusmateriaal, opdrachten, toetsen)", "Canvas (course materials, assignments, tests)", "https://login.canvas.uva.nl/"),
      UvaLink("Collegerooster", "Collegerooster", "Timetable", "https://student.uva.nl/rooster"),
      UvaLink("Studiegids", "Studiegids", "Study guide", "https://studiegids.uva.nl"),
      UvaLink("Studieresultaten", "Studieresultaten", "Study results", "https://student.uva.nl/studieresultaten"),
      UvaLink("Inschrijven voor cursussen", "Inschrijven voor cursussen", "Course registration", "https://glass.uva.nl/planning-board"),
    ]),
    UvaCategorie("Bibliotheek & studiemateriaal", "Library & study materials", Icons.menu_book, [
      UvaLink("Bibliotheekcatalogus", "Bibliotheekcatalogus", "Library catalogue", "https://lib.uva.nl"),
      UvaLink("Studieplekken zoeken", "Studieplekken zoeken", "Find a study space", "https://uba.uva.nl/bezoek-en-studeren/studieplekken/studieplekken.html"),
      UvaLink("Studieboeken en studiemateriaal", "Studieboeken en studiemateriaal", "Study books and materials", "https://student.uva.nl/informatie/studieboeken-en-studiemateriaal"),
      UvaLink("Bibliotheek: informatie voor studenten", "Bibliotheek: informatie voor studenten", "Library: information for students", "https://student.uva.nl/categorieen/bibliotheek-uva"),
    ]),
    UvaCategorie("Studieverenigingen", "Study associations", Icons.groups, [
      UvaLink("Studieverenigingen van de UvA", "Studieverenigingen van de UvA", "UvA study associations", "https://student.uva.nl/en/information/study-associations"),
      UvaLink("Studieverenigingen Rechtsgeleerdheid", "Studieverenigingen Rechtsgeleerdheid", "Study associations Law", "https://www.uva.nl/en/about-the-uva/organisation/faculties/amsterdam-law-school/education/study-associations/study-associations-law.html"),
      UvaLink("Studentenverenigingen", "Studentenverenigingen", "Student associations", "https://student.uva.nl/en/information/student-associations"),
    ]),
    UvaCategorie("Hulp & welzijn", "Support & well-being", Icons.favorite_border, [
      UvaLink("UvA-studentpsychologen", "UvA-studentpsychologen", "UvA student psychologists", "https://student.uva.nl/en/information/uva-psychologists"),
      UvaLink("Injebol Supportline (anoniem luisterend oor)", "Injebol Supportline (anoniem luisterend oor)", "Injebol Supportline (anonymous listening line)", "https://www.injebol.nl"),
    ]),
  ];
}
