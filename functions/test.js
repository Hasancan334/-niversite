// node test.js  -> tarih eşleştirme testleri
const assert = require("assert");
const { bugununMu, bugunTr, kisalt } = require("./tarih");

const b = { y: 2026, a: 11, g: 17 };
assert.ok(bugununMu({ sira: 20261117 }, b));
assert.ok(!bugununMu({ sira: 20261118, tarih: "17.11.2026" }, b));
assert.ok(bugununMu({ tarih: "17.11.2026" }, b));
assert.ok(bugununMu({ tarih: "17/11/2026 Salı" }, b));
assert.ok(bugununMu({ tarih: "17 Kasım Salı" }, b));
assert.ok(bugununMu({ tarih: "17 KASIM SALI" }, b));
assert.ok(!bugununMu({ tarih: "18 Kasım Çarşamba" }, b));
assert.ok(!bugununMu({ tarih: "" }, b));
// 21:30 UTC = ertesi gün 00:30 Türkiye
assert.deepStrictEqual(bugunTr(new Date("2026-11-17T21:30:00Z")), { y: 2026, a: 11, g: 18 });
assert.strictEqual(kisalt("a  b\nc", 10), "a b c");
assert.strictEqual(kisalt("abcdef", 4), "abc…");
console.log("Tüm testler geçti");
