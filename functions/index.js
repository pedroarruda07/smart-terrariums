const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.notifyOnThreshold = functions.database.ref('/Terrariums/{terrariumId}/activity/{date}/{hour}')
    .onUpdate((change, context) => {
        const newValue = change.after.val();
        const previousValue = change.before.val();

        const threshold = 30;

        if (newValue.temperature > threshold && previousValue.temperature <= threshold) {
            const payload = {
                notification: {
                    title: 'Alerta de Limite',
                    body: `O valor de temperature ultrapassou ${threshold}`,
                    sound: 'default',
                }
            };

            // Envie a notificação para o tópico "temperature"
            return admin.messaging().sendToTopic('temperature', payload)
                .then(response => {
                    console.log('Notificação enviada com sucesso:', response);
                    return null;
                })
                .catch(error => {
                    console.log('Erro ao enviar notificação:', error);
                    return null;
                });
        } else {
            return null;
        }
    });
