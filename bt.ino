#define BLUETOOTH_SPEED 38400 //This is the default baudrate that HC-05 uses
#include <SoftwareSerial.h>

// Swap RX/TX connections on bluetooth chip
//   Pin 10 --> Bluetooth TX
//   Pin 11 --> Bluetooth RX
SoftwareSerial mySerial(10, 11); // RX, TX

void setup(){
  Serial.begin(9600);
  mySerial.begin(9600);
}

//Uncomment this when setting up bluetooth
/*
void setup() {
  
  pinMode(9, OUTPUT);  // this pin will pull the HC-05 pin 34 (key pin) HIGH to switch module to AT mode
  digitalWrite(9, HIGH);
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  Serial.println("Starting config");
  mySerial.begin(BLUETOOTH_SPEED);
  delay(1000);

  // Should respond with OK
  mySerial.print("AT\r\n");
  waitForResponse();

  // Should respond with its version
  mySerial.print("AT+VERSION\r\n");
  waitForResponse();

  // Set pin to 0000
  mySerial.print("AT+PSWD=0000\r\n");
  waitForResponse();

  //Set baudrate to 9600
  mySerial.print("AT+UART=9600,0,0\r\n");
  waitForResponse();

  mySerial.print("AT+UART?\r\n");
  waitForResponse();

  String rnc = String("AT+NAME=") + String("HC-05-GABI") + String("\r\n"); 
  mySerial.print(rnc);
  waitForResponse();

  mySerial.print("AT+RESET\r\n");
  waitForResponse();

  Serial.println("Done!");
}}*/

void loop() {
  waitForResponse();  
}

void waitForResponse() {
    delay(1000);
    while (mySerial.available()) {
      Serial.write(mySerial.read());
    }
}
