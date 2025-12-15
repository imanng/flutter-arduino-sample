#include <ArduinoJson.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#define LEDPIN 17
#define SERVICE_UUID "87e3a34b-5a54-40bb-9d6a-355b9237d42b"
#define CHARACTERISTIC_UUID "cdc7651d-88bd-4c0d-8c90-4572db5aa14b"
#define SERVERNAME "ESP32 Sensor"

BLEServer* pServer = NULL;
BLEService* pService = NULL;
BLECharacteristic* esp32Characteristic = NULL;
BLEAdvertising* pAdvertising = NULL;

uint8_t ledStatus = 0;
bool deviceConnected = false;

DynamicJsonDocument sendDoc(1024);
DynamicJsonDocument receivedDoc(1024);

class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    Serial.println("Device: Connected!");
  };

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
    Serial.println("Device: Disconnected!");
    BLEDevice::startAdvertising();
  }
};

class CharacteristicCallback : public BLECharacteristicCallbacks {

  void onWrite(BLECharacteristic* dhtCharacteristic) {
    String value = dhtCharacteristic->getValue().c_str();

    deserializeJson(receivedDoc, value.c_str());

    const char* ledStatusData = receivedDoc["ledStatus"];
    if (ledStatusData) {
      if (strcmp(ledStatusData, "1") == 0) {
        ledStatus = 1;
        digitalWrite(LEDPIN, HIGH);
      } else {
        ledStatus = 0;
        digitalWrite(LEDPIN, LOW);
      }
    }
  }
};

void setupBle() {
  Serial.println("BLE initializing...");
  BLEDevice::init(SERVERNAME);

  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  pService = pServer->createService(SERVICE_UUID);
  esp32Characteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);

  esp32Characteristic->addDescriptor(new BLE2902());
  esp32Characteristic->setCallbacks(new CharacteristicCallback());

  pService->start();

  pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x12);

  BLEDevice::startAdvertising();

  Serial.println("BLE initialized. Waiting for client to connect...");
}

void setup() {
  Serial.begin(115200);
  pinMode(LEDPIN, OUTPUT);
  digitalWrite(LEDPIN, ledStatus);
  setupBle();
}