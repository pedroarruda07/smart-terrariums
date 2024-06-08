const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serviceAccount = require("./admin-key.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://scmu-terrariums-default-rtdb.europe-west1.firebasedatabase.app/",
});

exports.notifyOnThreshold = functions.database
    .ref("/Terrariums/-NxOimqv_QLBmqdP6ToG/temperature")
    .onUpdate((change, context) => {
      const newValue = change.after.val();
      const previousValue = change.before.val();

      if (newValue && previousValue) {
        if (newValue > 30 || newValue <= 0) {
          return admin.database()
              .ref("/Terrariums/-NxOimqv_QLBmqdP6ToG/name").once("value")
              .then((snapshot) => {
                const terrariumName = snapshot.val();
                const message = {
                  notification: {
                    title: "Temperature Alert",
                    body: "The temperature in " +
                    terrariumName + " has exceeded the limit!",
                  },
                  topic: "temperature",
                };

                return admin.messaging().send(message);
              })
              .then((response) => {
                console.log("Notification sent successfully:", response);
                return null;
              })
              .catch((error) => {
                console.log("Error sending notification:", error);
                return null;
              });
        } else {
          return null;
        }
      } else {
        console.log("Invalid temperature values.");
        return null;
      }
    });
