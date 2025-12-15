## Flutter and ESP32 BLE Communication for LED Control

### Project Description

This project demonstrates how to control an LED connected to the ESP32 from the mobile app. The project includes a mobile application built with Flutter and firmware for the ESP32.

### Features

- BLE Communication: Sends sensor data from ESP32 to the mobile app via BLE.
- LED Control: Allows turning the LED connected to the ESP32 on and off from the mobile app.
- Easy Setup and Usage: Simple and user-friendly setup for both hardware and software.

### Requirements

### Hardware Requirements

- ESP32 Development Board
- LED and 220Ω Resistor
- Connecting wires and breadboard

### Software Requirements

- Flutter 2.0+
- Arduino IDE
- ESP32 Arduino Core
- flutter_blue package (for Flutter)

### Hardware Setup

- Connecting led to ESP32:

- Connect the long leg (anode) of the LED to the GPIO17 pin of the ESP32 via a 220Ω resistor.
- Connect the shorter leg of the LED (cathode) to the GND pin of the ESP32.

### Usage

First download the codes in the main branch.

### Running the ESP32:

- Connect the ESP32 and upload the required code using Arduino IDE.
- The ESP32 will start broadcasting BLE data.

### Using the Mobile App:

- Run the Flutter application.
- The app will scan for nearby BLE devices.
- Select the ESP32 device and establish a connection.
- Sensor data will be displayed in the app, and LED control will be available.
