#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Wire.h>
#include <WiFi.h>
#include "time.h"
#include <DHT.h>
#include <DHT_U.h>
#include <ESP32Firebase.h>
#include <WiFi.h>
#include <WebServer.h>

//firebase
#define FIREBASE_HOST "https://scmu-terrariums-default-rtdb.europe-west1.firebasedatabase.app"
Firebase firebase(FIREBASE_HOST);
String terrarium = "/Terrariums/-NxOimqv_QLBmqdP6ToG";

//wifi
#define WIFI_SSID ""
#define WIFI_PASSWORD ""

//time
const char* ntpServer = "pool.ntp.org";
const long  gmtOffset_sec = 0;
const int   daylightOffset_sec = 3600;
struct tm timeinfo;

//temperature & humidity
#define DHTTYPE DHT11
const int dhtPin = 18;
DHT dht(dhtPin, DHTTYPE);
float temperature = 0;
float humidity = 0;

//leds
const int ledPin = 27;
const int alarmLed = 13;

//firebase info
float maxTemp = 0;
float minTemp = 0;
float maxHumid = 0;
float minHumid = 0;
float offLight = 0;
float onLight = 0;
String ledStatus = "";
String manualOverride = "";

//display screen
#define SCREEN_WIDTH 128 
#define SCREEN_HEIGHT 64 
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);

//water-level
#define POWER 33
#define SIGNAL 32
int waterLevel=0;

//movement-sensor
const int PIR_PIN = 14; 
int warm_up;

WebServer server(80);

void printLocalTime()
{
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
    return;
  }
  Serial.println(&timeinfo, "%A, %B %d %Y %H:%M:%S");
}

void setup() {
  Serial.begin(115200);
  dht.begin();
  pinMode(PIR_PIN, INPUT);
  delay(20000);
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

  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  printLocalTime();

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

  server.on("/led/on", HTTP_GET, []() {
    digitalWrite(ledPin, HIGH);
    server.send(200, "text/plain", "LED is ON");
  });

  server.on("/led/off", HTTP_GET, []() {
    digitalWrite(ledPin, LOW);
    server.send(200, "text/plain", "LED is OFF");
  });

  server.begin();
  Serial.println("Setup Done!");
}

void loop() {
  
  printLocalTime();
  getFromFirebase();
  server.handleClient();
  updateLed();
  updateSensorInfo();
  movementSensor();
  updateAlarm();
  displayScreen(temperature, humidity);
  sendToFirebase();

  delay(10);
}

void getFromFirebase()
{
  maxTemp = firebase.getFloat(terrarium+"/maxTemp");
  minTemp = firebase.getFloat(terrarium+"/minTemp");
  maxHumid = firebase.getFloat(terrarium+"/maxHumidity");
  minHumid = firebase.getFloat(terrarium+"/minHumidity");
  offLight = firebase.getFloat(terrarium+"/maxLight");
  onLight = firebase.getFloat(terrarium+"/minLight");
  ledStatus = firebase.getString(terrarium+"/ledStatus");
  manualOverride = firebase.getString(terrarium+"/manualOverride");    
}

void sendToFirebase()
{
  firebase.setFloat(terrarium+"/temperature", temperature);
  firebase.setFloat(terrarium+"/humidity", humidity);
  firebase.setInt(terrarium+"/waterLevel", waterLevel);
  firebase.setString(terrarium+"/ledStatus", ledStatus);
  //firebase.setString(terrarium+"/manualOverride", manualOverride); 
}

void updateLed()
{
  if (timeinfo.tm_hour == offLight){
    manualOverride = "OFF";
  }

  if (manualOverride == "OFF"){
    if (timeinfo.tm_hour >= onLight && timeinfo.tm_hour < offLight){
      if (ledStatus == "OFF"){
        digitalWrite(ledPin, HIGH);
        ledStatus = "ON";
      }
    }else {
      if (ledStatus == "ON") {
        digitalWrite(ledPin, LOW);
        ledStatus = "OFF";
      }
    } 
  } else {
    if (ledStatus == "ON"){
      digitalWrite(ledPin, HIGH);
    } else {
      digitalWrite(ledPin, LOW);
    }
  }
}

void updateSensorInfo()
{
  temperatureAndHumidity();
  waterSensor();
}

void waterSensor()
{
  digitalWrite(POWER,HIGH);
  delay(10);
  waterLevel=analogRead(SIGNAL);
  delay(10);
  digitalWrite(POWER,LOW);
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

void temperatureAndHumidity()
{
  humidity = dht.readHumidity();
  temperature = dht.readTemperature();
  if (isnan(humidity) || isnan(temperature)) {
    Serial.println("Failed reception");
    return;
  }
}

void movementSensor()
{
  int sensor_output;
  sensor_output = digitalRead(PIR_PIN);
  if( sensor_output == LOW )
  {
    if( warm_up == 1 )
     {
      Serial.print("Warming Up\n\n");
      warm_up = 0;
      delay(2000);
    }
    Serial.print("No object in sight\n\n");
    delay(1000);
  }
  else
  {
    Serial.print("Object detected\n\n"); 
    updateActivity();  
    warm_up = 1;
    delay(1000);
  } 
}

void updateActivity() {
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
    return;
  }

  char dateStr[11];
  strftime(dateStr, sizeof(dateStr), "%d-%m-%Y", &timeinfo);

  String datePath = terrarium + "/activity/" + dateStr;
  String hourStr = String(timeinfo.tm_hour);

  int currentActivity = firebase.getInt(datePath + "/" + hourStr);

  if (currentActivity == -1) {
    currentActivity = 0;
  }

  firebase.setInt(datePath + "/" + hourStr, currentActivity + 1);
}

void updateAlarm()
{
  if (temperature < minTemp || temperature > maxTemp || waterLevel < 100 || humidity < minHumid || humidity > maxHumid){
    digitalWrite(alarmLed, HIGH);
  } else {
    digitalWrite(alarmLed, LOW);
  }
}
