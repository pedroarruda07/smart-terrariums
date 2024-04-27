#include <ESP32Firebase.h>
#include <WiFi.h>


#define FIREBASE_HOST "https://scmu-terrariums-default-rtdb.europe-west1.firebasedatabase.app"
#define FIREBASE_AUTH "1doYq2Dc7E3rPm16zLepaFHaUscq8m0r9JOJ8pxP"

#define WIFI_SSID "Vodafone-9941A4"
#define WIFI_PASSWORD "RRVc6MnsYT"

const int ledPin = 27;

Firebase firebase(FIREBASE_HOST);
String path = "/LEDStatus";

void setup() {
  Serial.begin(115200);
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());

  //Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  //Firebase.reconnectWiFi(true);
}

void loop() {
  
  String value = firebase.getString(path);
  if (value == "ON") {
    digitalWrite(ledPin, HIGH);
  } else if (value == "OFF") {
    digitalWrite(ledPin, LOW);
  }

  delay(1000); // Adjust timing as needed
}
