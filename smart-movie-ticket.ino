#include <SPI.h>               //for RFID Module (rfid-rc522)
#include <MFRC522.h>           //for RFID Module (rfid-rc522)
#include <stdio.h>             //for RTC Module (ds1302)
#include <DS1302.h>            //for RTC Module (ds1302)
#include <Wire.h>              //for LCD 16x2 with I2C
#include <LiquidCrystal_I2C.h> //for LCD 16x2 with I2C

/* RFID Module Variables */
#define RST_PIN 9 // Configurable, see typical pin layout above
#define SS_PIN 10 // Configurable, see typical pin layout above
MFRC522 mfrc522(SS_PIN, RST_PIN);   // Create MFRC522 instance.
MFRC522::MIFARE_Key key;
/* RTC Module Variables */
const int kCePin   = 5;  // Chip Enable
const int kIoPin   = 6;  // Input/Output
const int kSclkPin = 7;  // Serial Clock
DS1302 rtc(kCePin, kIoPin, kSclkPin); // Create a DS1302 object.
String dayAsString(const Time::Day day) {
  switch (day) {
    case Time::kSunday: return "Sunday";
    case Time::kMonday: return "Monday";
    case Time::kTuesday: return "Tuesday";
    case Time::kWednesday: return "Wednesday";
    case Time::kThursday: return "Thursday";
    case Time::kFriday: return "Friday";
    case Time::kSaturday: return "Saturday";
  }
  return "(unknown day)";
}
/* LCD 16x2 with I2C Variables */
// Set the LCD address to 0x26 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd(0x26, 16, 2);

void setup() {
  Serial.begin(9600); // Initialize serial communications with the PC
  
  /* RFID Module Initialization */
  SPI.begin();        // Init SPI bus
  mfrc522.PCD_Init(); // Init MFRC522 card
  
  /* RTC Module Initialization */
  rtc.writeProtect(false);
  rtc.halt(false);
  //Time t(2017, 5, 28, 20, 16, 00, Time::kSunday); //Make a new time and date object
  //rtc.time(t); //Set time and date on the chip

  /* LCD 16x2 with I2C Initialization */
  lcd.begin();
  lcd.backlight();
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("TEST");
}

void loop() {
  if ( ! mfrc522.PICC_IsNewCardPresent())
    return;
  // Select one of the cards
  if ( ! mfrc522.PICC_ReadCardSerial())
    return;
  dump_byte_array(mfrc522.uid.uidByte, mfrc522.uid.size);
  Serial.println("");
  String returnData;
  returnData = Serial.readStringUntil('\n');
  mfrc522.PICC_HaltA();
}

void dump_byte_array(byte *buffer, byte bufferSize) {
    for (byte i = 0; i < bufferSize; i++) {
        Serial.print(buffer[i] < 0x10 ? " 0" : " ");
        Serial.print(buffer[i], HEX);
    }
}

void printTime() {
  // Get the current time and date from the chip.
  Time t = rtc.time();
  // Name the day of the week.
  const String day = dayAsString(t.day);
  // Format the time and date and insert into the temporary buffer.
  char buf[50];
  snprintf(buf, sizeof(buf), "%s %04d-%02d-%02d %02d:%02d:%02d",
           day.c_str(),
           t.yr, t.mon, t.date,
           t.hr, t.min, t.sec);
  // Print the formatted string to serial so we can see the time.
  Serial.println(buf);
}
