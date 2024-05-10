#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Wire.h>

#include <DHT.h>
#include <DHT_U.h>

#include <ESP32Firebase.h>
#include <WiFi.h>

#define FIREBASE_HOST "https://scmu-terrariums-default-rtdb.europe-west1.firebasedatabase.app"
Firebase firebase(FIREBASE_HOST);
String terrarium = "/Terrariums/-NxOimqv_QLBmqdP6ToG";

#define WIFI_SSID "Vodafone-9941A4"
#define WIFI_PASSWORD "RRVc6MnsYT"

#define DHTTYPE DHT11
const int dhtPin = 18;
DHT dht(dhtPin, DHTTYPE);

const int ledPin = 27;

#define SCREEN_WIDTH 128 
#define SCREEN_HEIGHT 64 
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);

void setup() {
  Serial.begin(115200);
  dht.begin();
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

  if(!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println(F("SSD1306 allocation failed"));
    for(;;);
  }

  delay(500);
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(0, 10);
  display.println("Display Screen ON");
  display.display(); 
}

void loop() {
  
  String value = firebase.getString(terrarium+"/ledStatus");
  if (value == "ON") {
    digitalWrite(ledPin, HIGH);
  } else if (value == "OFF") {
    digitalWrite(ledPin, LOW);
  }

  float h = dht.readHumidity();
  float t = dht.readTemperature();
  if (isnan(h) || isnan(t)) {
    Serial.println("Failed reception");
    return;
    //Returns an error if the ESP32 does not receive any measurements
  }
  firebase.setFloat(terrarium+"/temperature", t);
  firebase.setFloat(terrarium+"/humidity", h);

  display.clearDisplay();
  display.setCursor(0, 10);
  display.print("Temperature: ");
  display.print(t);
  display.println(" C");
  display.print("Humidity: ");
  display.print(h);
  display.print("%");
  display.display();
  delay(1000);
}
