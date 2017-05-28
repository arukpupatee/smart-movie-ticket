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

/* LED , Buzzer Variables */
const int LED_Pin = 4;
const int Buzzer_Pin = 3;

void setup() {
  Serial.begin(9600); // Initialize serial communications with the PC
  pinMode(LED_Pin,OUTPUT);
  pinMode(Buzzer_Pin,OUTPUT);
  
  /* RFID Module Initialization */
  SPI.begin();        // Init SPI bus
  mfrc522.PCD_Init(); // Init MFRC522 card
  
  /* RTC Module Initialization */
  rtc.writeProtect(false);
  rtc.halt(false);
  Time t(2017, 5, 28, 10, 50, 00, Time::kSunday); //Make a new time and date object
  rtc.time(t); //Set time and date on the chip

  /* LCD 16x2 with I2C Initialization */
  lcd.begin();
  lcd.backlight();
  lcd.clear();
  lcd.setCursor(0, 0);
}

void loop() {
  //default lcd show date and time
  lcd.clear();
  Time t = rtc.time();
  lcd.setCursor(0, 0);
  lcd.print(String(t.yr)+"-"+String(t.mon)+"-"+String(t.date));
  lcd.setCursor(0, 1);
  lcd.print(String(t.hr)+":"+String(t.min)+":"+String(t.sec));
  
  if ( ! mfrc522.PICC_IsNewCardPresent())
    return;
  // Select one of the cards
  if ( ! mfrc522.PICC_ReadCardSerial())
    return;

  //if scan card then send data to server
  dump_byte_array(mfrc522.uid.uidByte, mfrc522.uid.size);
  Serial.print(";");
  printTime();
  Serial.println("");
  //read data return from server
  String return_data;
  return_data = Serial.readStringUntil('\n');
  lcd.clear();
  digitalWrite(LED_Pin,HIGH);
  digitalWrite(Buzzer_Pin,HIGH);
  if ( return_data.equals("Ticket Mismatch") || return_data.equals("Not in time") ){
    lcd.print(return_data);
    for(int t=0;t<=2000;t=t+100){
      digitalWrite(LED_Pin,HIGH);
      digitalWrite(Buzzer_Pin,HIGH);
      delay(50);
      digitalWrite(LED_Pin,LOW);
      digitalWrite(Buzzer_Pin,LOW);
      delay(50);
    }
  }
  else{
    //String movie_name,st_time,hall_name,seat_id;
    int scIndex0 = return_data.indexOf(';');
    int scIndex1 = return_data.indexOf(';',scIndex0+1);
    int scIndex2 = return_data.indexOf(';',scIndex1+1);
    String movie_name = return_data.substring(0,scIndex0);
    String st_time = return_data.substring(scIndex0+1,scIndex1);
    String hall_name = return_data.substring(scIndex1+1,scIndex2);
    String seat_id = return_data.substring(scIndex2+1);
    lcd.print(movie_name);
    lcd.setCursor(0, 1);
    lcd.print(st_time);
    delay(700);
    digitalWrite(Buzzer_Pin,LOW);
    delay(2300);
    lcd.clear();
    lcd.print(movie_name);
    lcd.setCursor(0, 1);
    lcd.print(hall_name+" "+seat_id);
    delay(3000);
    digitalWrite(LED_Pin,LOW);
  }
  mfrc522.PICC_HaltA();
}

void dump_byte_array(byte *buffer, byte bufferSize) {
    for (byte i = 0; i < bufferSize; i++) {
        //Serial.print(buffer[i] < 0x10 ? " 0" : " ");
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
  Serial.print(buf);
}
