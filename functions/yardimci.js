// Saf yardımcılar (Firebase'e bağımlı değil; test.js ile denenir)

/** Boşlukları sadeleştirip en fazla n karaktere kısaltır */
function kisalt(s, n) {
  s = String(s || "").replace(/\s+/g, " ").trim();
  return s.length > n ? s.slice(0, n - 1) + "…" : s;
}

module.exports = { kisalt };
