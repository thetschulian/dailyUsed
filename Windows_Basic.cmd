echo Download newest Version from Github
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/thetschulian/dailyUsed/main/Windows_Basic.cmd' -OutFile 'Windows_Basic.cmd'

echo Win10 style rechtsklick
echo enable Seconds on Taskbar Clock
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v ShowSecondsInSystemClock /t REG_DWORD /d 1
echo disable win11 contect menu quasi das weitere optionen beim rechtsklicken
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
echo disable win11 explorer command bar 
reg.exe add "HKCU\Software\Classes\CLSID\{d93ed569-3b3e-4bff-8355-3c44f6a52bb5}\InprocServer32" /f /ve
echo Other Design Settings
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v LaunchTo /t REG_DWORD /d 1
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v TaskbarGlomLevel /t REG_DWORD /d 2
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced " /f /v TaskbarGlomLevel /t REG_DWORD /d 2
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v MMTaskbarEnabled /t REG_DWORD /d 1
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v MMTaskbarGlomLevel /t REG_DWORD /d 2
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v MMTaskbarMode /t REG_DWORD /d 2

Echo Disable SHARE Button on Taskbar Previews
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSn /t REG_DWORD /d 0 /f

rem Echo Install Powertoys
rem winget install Microsoft.PowerToys --source winget

Echo Install Lenovo Commercial Vantage
winget install "Lenovo Commercial Vantage" --source=msstore --accept-package-agreements --accept-source-agreements

Echo debloat windows
winget uninstall "Microsoft 365 Copilot" --accept-source-agreements
winget uninstall "Feedback Hub" --accept-source-agreements
winget uninstall "Game Bar" --accept-source-agreements
winget uninstall "Power Automate" --accept-source-agreements
winget uninstall "Microsoft Bing" --accept-source-agreements
winget uninstall "Microsoft Clipchamp" --accept-source-agreements
winget uninstall "Xbox TCUI" --accept-source-agreements
winget uninstall "Phone Link" --accept-source-agreements
winget uninstall "Windows Media Player" --accept-source-agreements
winget uninstall "Microsoft To Do" --accept-source-agreements
winget uninstall "Solitaire & Casual Games" --accept-source-agreements
winget uninstall "MSN Weather" --accept-source-agreements
winget uninstall "Copilot" --accept-source-agreements
winget uninstall "Xbox" --accept-source-agreements
winget uninstall "Xbox Identity Provider" --accept-source-agreements
winget uninstall "Quick Assist" --accept-source-agreements
winget uninstall "Game Speech Window" --accept-source-agreements
winget uninstall "Get Help" --accept-source-agreements
winget uninstall "Microsoft Edge Game Assist" --accept-source-agreements
winget list

echo run as admin

pause 

Echo CPU Performance Boost (as Local ADMIN)
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v Attributes /t REG_DWORD /d 2 /f

 echo  Kill A Scheduled Task (as Local Admin)
schtasks /create /tn "daily_Kill_Tool" /tr "C:\Windows\System32\taskkill.exe /IM Tool.exe /F" /sc daily /st 20:00 /ru "SYSTEM"


pause
