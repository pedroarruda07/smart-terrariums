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

      console.log("Trigger function executed");
      console.log("Previous Value:", previousValue);
      console.log("New Value:", newValue);
      console.log("New Value.temperature:", newValue.temperature);

      if (newValue && previousValue) {
        console.log("Both previous and new values are valid.");
        if (
          newValue > 30 ||
          newValue <= 0
        ) {
          const message = {
            data: {
              title: "Alerta de Limite",
              body: "O valor de temperature ultrapassou o limite!",
            },
            topic: "temperature",
          };

          return admin.messaging().send(message)
              .then((response) => {
                console.log("Notificação enviada com sucesso:", response);
                return null;
              })
              .catch((error) => {
                console.log("Erro ao enviar notificação:", error);
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
