// Toros Genç Mobil - push bildirimleri (Firebase Cloud Functions, 2. nesil)
//
// Uygulama 3 konuya (topic) abone olur: sohbet, yemek, duyuru
//  1) sohbetBildirimi : sohbet odasına her 5 mesajda bir bildirim
//  2) gununMenusu     : her gün 11:00'de (Türkiye saati) günün yemek menüsü
//  3) duyuruBildirimi : yönetici ekranında "bildirim gönder" işaretli
//                       (ya da JSON'da "bildirim": true) yeni duyuru/etkinlik
//
// Kurulum ve yayınlama: TOROS_NOTLAR.md

const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");
const { setGlobalOptions } = require("firebase-functions/v2");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const logger = require("firebase-functions/logger");
const { SAAT_DILIMI, bugunTr, bugununMu, kisalt } = require("./tarih");

// Firestore konumu "eur3" ise europe-west1, "nam5" ise us-central1,
// tek bölge ise (ör. europe-west3) aynısını yaz.
const BOLGE = "europe-west1";

// Sohbet: kaç mesajda bir bildirim ve iki bildirim arasında en az kaç dakika
// (çok hareketli sohbette telefonlar sürekli ötmesin diye).
const SOHBET_MESAJ_ARALIGI = 5;
const SOHBET_EN_AZ_DAKIKA = 10;

setGlobalOptions({ region: BOLGE, maxInstances: 5 });
initializeApp();

const db = () => getFirestore();

async function gonder(topic, baslik, metin, veri = {}) {
  const id = await getMessaging().send({
    topic,
    notification: { title: baslik, body: metin },
    data: { ekran: topic, ...veri },
    android: { priority: "high", notification: { sound: "default" } },
    apns: { payload: { aps: { sound: "default" } } },
  });
  logger.info(`Bildirim gönderildi (${topic}): ${baslik}`, { id });
}

// ---------------------------------------------------------------- 1) SOHBET
exports.sohbetBildirimi = onDocumentCreated("sohbet/{mesajId}", async () => {
  const ref = db().doc("sayaclar/sohbet");
  const gonderilsin = await db().runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const d = snap.exists ? snap.data() : {};
    const adet = (d.adet || 0) + 1;
    const son = d.sonBildirim ? d.sonBildirim.toMillis() : 0;
    const yeterinceZaman =
      Date.now() - son >= SOHBET_EN_AZ_DAKIKA * 60 * 1000;
    const gonder = adet % SOHBET_MESAJ_ARALIGI === 0 && yeterinceZaman;
    const yeni = { adet };
    if (gonder) yeni.sonBildirim = FieldValue.serverTimestamp();
    tx.set(ref, yeni, { merge: true });
    return gonder;
  });
  if (!gonderilsin) return;
  await gonder(
    "sohbet",
    "💬 Goygoy Odası",
    "Sohbet odasında sohbet başladı, sen de katıl!"
  );
});

// ---------------------------------------------------------- 2) GÜNÜN MENÜSÜ
exports.gununMenusu = onSchedule(
  { schedule: "0 11 * * *", timeZone: SAAT_DILIMI },
  async () => {
    const bugun = bugunTr();
    const snap = await db().collection("yemekler").get();
    const kayit = snap.docs
      .map((d) => d.data())
      .find((m) => m.aktif !== false && bugununMu(m, bugun));
    if (!kayit || !String(kayit.yemek || "").trim()) {
      logger.info("Bugün için menü yok, bildirim gönderilmedi", bugun);
      return;
    }
    const menu = String(kayit.yemek)
      .split("\n").map((s) => s.trim()).filter(Boolean).join(", ");
    await gonder("yemek", "🍽️ Günün menüsü", kisalt(menu, 180));
  }
);

// ------------------------------------------------- 3) DUYURU / ETKİNLİK
exports.duyuruBildirimi = onDocumentCreated(
  "duyuru_etkinlik/{id}",
  async (event) => {
    const m = event.data && event.data.data();
    if (!m || m.bildirim !== true || m.aktif === false) return;
    const baslik = m.tip === "etkinlik" ? "🎉 Yeni etkinlik" : "📢 Yeni duyuru";
    const metin = kisalt(m.baslik || m.icerik || "Detaylar uygulamada", 180);
    await gonder("duyuru", baslik, metin, { id: event.params.id });
    await event.data.ref.update({
      bildirimGonderildi: FieldValue.serverTimestamp(),
    });
  }
);
