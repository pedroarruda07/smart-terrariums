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

const int alarmLed = 13;
float maxTemp = 0;
float minTemp = 0;

#define SCREEN_WIDTH 128 
#define SCREEN_HEIGHT 64 
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);

#define POWER 33
#define SIGNAL 32
int value=0;
int level=0;

void setup() {
  Serial.begin(115200);
  dht.begin();
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
  pinMode(alarmLed, OUTPUT);
  digitalWrite(alarmLed, LOW);

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

  pinMode(POWER,OUTPUT);
  digitalWrite(POWER,LOW);

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
  
  maxTemp = firebase.getFloat(terrarium+"/maxTemp");
  minTemp = firebase.getFloat(terrarium+"/minTemp");
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  if (isnan(h) || isnan(t)) {
    Serial.println("Failed reception");
    return;
  }
  firebase.setFloat(terrarium+"/temperature", t);
  firebase.setFloat(terrarium+"/humidity", h);

  if (t < minTemp || t > maxTemp){
    digitalWrite(alarmLed, HIGH);
  } else {
    digitalWrite(alarmLed, LOW);
  }

  displayScreen(t, h);
  level=waterSensor();
  Serial.print("Water Level:");
  Serial.println(level);
  delay(1000);
}

int waterSensor()
{
  digitalWrite(POWER,HIGH);
  delay(10);
  value=analogRead(SIGNAL);
  delay(10);
  digitalWrite(POWER,LOW);
  return value;
}

void displayScreen(float t, float h)
{
  display.clearDisplay();
  display.setCursor(0, 10);
  display.print("Temperature: ");
  display.print(t);
  display.println(" C");
  display.print("Humidity: ");
  display.print(h);
  display.print("%");
  display.display();
}
