// Saf yardımcılar (Firebase'e bağımlı değil; test.js ile denenir)

const SAAT_DILIMI = "Europe/Istanbul";

function kisalt(s, n) {
  s = String(s || "").replace(/\s+/g, " ").trim();
  return s.length > n ? s.slice(0, n - 1) + "…" : s;
}

const AYLAR = {
  ocak: 1, şubat: 2, subat: 2, mart: 3, nisan: 4, mayıs: 5, mayis: 5,
  haziran: 6, temmuz: 7, ağustos: 8, agustos: 8, eylül: 9, eylul: 9,
  ekim: 10, kasım: 11, kasim: 11, aralık: 12, aralik: 12,
};

/** Türkiye saatine göre bugün: {y, a, g} */
function bugunTr(simdi = new Date()) {
  const p = Object.fromEntries(
    new Intl.DateTimeFormat("en-CA", {
      timeZone: SAAT_DILIMI, year: "numeric", month: "2-digit", day: "2-digit",
    }).formatToParts(simdi).map((x) => [x.type, x.value])
  );
  return { y: +p.year, a: +p.month, g: +p.day };
}

/**
 * Yemek kaydı bugüne mi ait? Uygulamadaki (yemek_listesi_screen.dart) mantıkla
 * aynı: önce "sira" (20261117), yoksa "tarih" ("17.11.2026" ya da "17 Kasım Salı").
 */
function bugununMu(m, bugun) {
  const sira = Number(m.sira);
  if (Number.isFinite(sira) && sira > 20000000) {
    return sira === bugun.y * 10000 + bugun.a * 100 + bugun.g;
  }
  const t = String(m.tarih || "");
  const r1 = t.match(/(\d{1,2})[./-](\d{1,2})[./-](\d{4})/);
  if (r1) return +r1[1] === bugun.g && +r1[2] === bugun.a && +r1[3] === bugun.y;
  const r2 = t.match(/(\d{1,2})\s+([A-Za-zÇĞİÖŞÜçğıöşü]+)/);
  if (r2) {
    const ay = AYLAR[r2[2].toLocaleLowerCase("tr-TR")];
    return ay === bugun.a && +r2[1] === bugun.g;
  }
  return false;
}

module.exports = { SAAT_DILIMI, bugunTr, bugununMu, kisalt };
