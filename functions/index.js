const admin = require("firebase-admin");
admin.initializeApp();

const { onDocumentCreated } = require("firebase-functions/v2/firestore");

// NEWS -> topic: news
exports.onNewsCreated = onDocumentCreated("news/{newsId}", async (event) => {
  const newsId = event.params.newsId;
  const data = event.data?.data() || {};

  const title = data.title || "خبر جديد";
  const body = data.summary || "اضغط لعرض التفاصيل";

  await admin.messaging().send({
    topic: "news",
    notification: { title, body },
    data: {
      type: "news",
      targetId: String(newsId),
    },
  });

  await admin.firestore().collection("notifications").add({
    title,
    body,
    type: "news",
    targetId: newsId,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    sent: true,
  });
});

// EVENTS -> topic: events
exports.onEventCreated = onDocumentCreated("events/{eventId}", async (event) => {
  const eventId = event.params.eventId;
  const data = event.data?.data() || {};

  const title = data.title || "فعالية جديدة";
  const body = data.summary || "اضغط لعرض التفاصيل";

  await admin.messaging().send({
    topic: "events",
    notification: { title, body },
    data: {
      type: "event",
      targetId: String(eventId),
    },
  });

  await admin.firestore().collection("notifications").add({
    title,
    body,
    type: "event",
    targetId: eventId,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    sent: true,
  });
});
