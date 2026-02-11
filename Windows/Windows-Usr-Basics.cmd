@echo off
echo "Last Edited 10.02.2026"
echo %DATE% %TIME% Script started.
echo Run this in CMD only - powershell will cause errors
echo.
echo Tested on Win11 22H1,22H2,23H1,23H2,24H2,25H2
echo.
echo.
echo Todos
echo 1. Start the newly downloaded script but dont dont download again to avoid a loop. use a parameter to "call" the batch file?
echo 2. Upload a Picture to github and add a download command to download the newly uploaded picture which is then used for the wallpaper change 

echo Press any Key to start.

pause

set basicTempDir=C:\temp
echo "Creating Basic Temp Directory %basicTempDir%"
mkdir %basicTempDir%

echo "Download newest Version to %basicTempDir%"
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/thetschulian/dailyUsed/main/Windows/Windows-Usr-Basics.cmd' -OutFile '%basicTempDir%\Windows-Usr-Basics.cmd'"

echo "Download Teamviewer Quicksupport to %basicTempDir%"
powershell -Command "Start-BitsTransfer -Source 'https://dl.teamviewer.com/download/TeamViewerQS.exe' -Destination '%basicTempDir%\TeamviewerQS.exe'"

echo. 
echo Win10 style rechtsklick
echo enable Seconds on Taskbar Clock
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v ShowSecondsInSystemClock /t REG_DWORD /d 1
echo disable win11 contect menu quasi das weitere optionen beim rechtsklicken
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
echo disable win11 explorer command bar 
reg.exe add "HKCU\Software\Classes\CLSID\{d93ed569-3b3e-4bff-8355-3c44f6a52bb5}\InprocServer32" /f /ve
echo Disable Task View
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f
echo. 
echo Other Design Settings
echo.
echo "Skipping Set the Wallpaper"
echo powershell -Command "(Add-Type -MemberDefinition '[DllImport(\"user32.dll\")] public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);' -Name NativeMethods -Namespace WinAPI -PassThru)::SystemParametersInfo(20, 0, 'C:\temp\Wallpaper_Win11_FullHD.jpg', 3)"
echo.
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v LaunchTo /t REG_DWORD /d 1
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v TaskbarGlomLevel /t REG_DWORD /d 2
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v MMTaskbarEnabled /t REG_DWORD /d 1
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v MMTaskbarGlomLevel /t REG_DWORD /d 2
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v MMTaskbarMode /t REG_DWORD /d 2
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v TaskbarDa /t REG_DWORD /d 0 
echo turn on dark mode
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
echo.
echo. 
echo Disable the Search Box
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search /f /v SearchBoxTaskbarMode /t REG_DWORD /d 0 
echo. 
echo Show My Computer on Desktop
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f
echo. 
echo Taskmaanger Default Register performance
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\TaskManager /f /v StartUpTab /t REG_DWORD /d 1 
echo. 
echo Add END TASK to Taskbar
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings /f /v TaskbarEndTask /t REG_DWORD /d 1 
echo. 
Echo Disable SHARE Button on Taskbar Previews
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSn /t REG_DWORD /d 0 /f
echo. 
echo.
echo.
echo "Restarting explorer.exe now"
taskkill /f /im explorer.exe & start explorer.exe
timeout 5 >nul
echo "Skipping: Install Powertoys"
rem  winget install Microsoft.PowerToys --source winget
echo. 
echo "Skipping: Install Lenovo Commercial Vantage"
rem winget install "Lenovo Commercial Vantage" --source=msstore --accept-package-agreements --accept-source-agreements
echo. 
echo "Debloat Windows"
echo. 
echo "winget uninstall Microsoft 365 Copilot --accept-source-agreements"
winget uninstall "Microsoft 365 Copilot" --accept-source-agreements
winget uninstall "Microsoft 365 Copilot" --accept-source-agreements

echo "winget uninstall Copilot --accept-source-agreements"
winget uninstall "Copilot" --accept-source-agreements

echo "winget uninstall Feedback Hub --accept-source-agreements"
winget uninstall "Feedback Hub" --accept-source-agreements

echo "winget uninstall Feedback-Hub --accept-source-agreements"
winget uninstall "Feedback-Hub" --accept-source-agreements

echo "winget uninstall Schnellhilfe --accept-source-agreements"
winget uninstall "Schnellhilfe" --accept-source-agreements

echo "winget uninstall Game Bar --accept-source-agreements"
winget uninstall "Game Bar" --accept-source-agreements

echo "Skipping: winget uninstall Paint --accept-source-agreements"
::winget uninstall "Paint" --accept-source-agreements

echo "winget uninstall Cortana --accept-source-agreements"
winget uninstall "Cortana" --accept-source-agreements

echo "winget uninstall News --accept-source-agreements"
winget uninstall "News" --accept-source-agreements

echo "winget uninstall Microsoft News --accept-source-agreements"
winget uninstall "Microsoft News" --accept-source-agreements

echo "winget uninstall Microsoft News – Nachrichten --accept-source-agreements"
winget uninstall "Microsoft News – Nachrichten" --accept-source-agreements

echo "winget uninstall Windows Medienwiedergabe --accept-source-agreements"
winget uninstall "Windows Medienwiedergabe" --accept-source-agreements

echo "winget uninstall Microsoft Teams --accept-source-agreements"
winget uninstall "Microsoft Teams" --accept-source-agreements

echo "winget uninstall Microsoft 365 (Office) --accept-source-agreements"
winget uninstall "Microsoft 365 (Office)" --accept-source-agreements

echo "winget uninstall Movies & TV --accept-source-agreements"
winget uninstall "Movies & TV " --accept-source-agreements

echo "winget uninstall Power Automate --accept-source-agreements"
winget uninstall "Power Automate" --accept-source-agreements

echo "winget uninstall Microsoft Bing --accept-source-agreements"
winget uninstall "Microsoft Bing" --accept-source-agreements

echo "winget uninstall Microsoft Tips --accept-source-agreements"
winget uninstall "Microsoft Tips" --accept-source-agreements

echo "winget uninstall Microsoft People --accept-source-agreements"
winget uninstall "Microsoft People" --accept-source-agreements

echo "winget uninstall Microsoft Photos --accept-source-agreements"
winget uninstall "Microsoft Photos" --accept-source-agreements

echo "winget uninstall Microsoft Sticky Notes --accept-source-agreements"
winget uninstall "Microsoft Sticky Notes" --accept-source-agreements

echo "winget uninstall Microsoft Clipchamp --accept-source-agreements"
winget uninstall "Microsoft Clipchamp" --accept-source-agreements

echo "winget uninstall Phone Link --accept-source-agreements"
winget uninstall "Phone Link" --accept-source-agreements

echo "winget uninstall Smartphone Link --accept-source-agreements"
winget uninstall "Smartphone Link" --accept-source-agreements

echo "winget uninstall Smartphone-Link --accept-source-agreements"
winget uninstall "Smartphone-Link" --accept-source-agreements

echo "winget uninstall Windows Media Player --accept-source-agreements"
winget uninstall "Windows Media Player" --accept-source-agreements

echo "winget uninstall Outlook for Windows --accept-source-agreements"
winget uninstall "Outlook for Windows" --accept-source-agreements

echo "winget uninstall Microsoft To Do --accept-source-agreements"
winget uninstall "Microsoft To Do" --accept-source-agreements

echo "winget uninstall Solitaire & Casual Games --accept-source-agreements"
winget uninstall "Solitaire & Casual Games" --accept-source-agreements

echo "winget uninstall MSN Weather --accept-source-agreements"
winget uninstall "MSN Weather" --accept-source-agreements

echo "winget uninstall MSN Wetter --accept-source-agreements"
winget uninstall "MSN Wetter" --accept-source-agreements

echo "winget uninstall Xbox TCUI --accept-source-agreements"
winget uninstall "Xbox TCUI" --accept-source-agreements

echo "winget uninstall Xbox --accept-source-agreements"
winget uninstall "Xbox" --accept-source-agreements

echo "winget uninstall Xbox Game Bar Plugin --accept-source-agreements"
winget uninstall "Xbox Game Bar Plugin" --accept-source-agreements

echo "winget uninstall Xbox Game Speech Window --accept-source-agreements"
winget uninstall "Xbox Game Speech Window" --accept-source-agreements

echo "winget uninstall Xbox Identity Provider --accept-source-agreements"
winget uninstall "Xbox Identity Provider" --accept-source-agreements

echo "winget uninstall Quick Assist --accept-source-agreements"
winget uninstall "Quick Assist" --accept-source-agreements

echo "winget uninstall Game Speech Window --accept-source-agreements"
winget uninstall "Game Speech Window" --accept-source-agreements

echo "winget uninstall Get Help --accept-source-agreements"
winget uninstall "Get Help" --accept-source-agreements

echo "winget uninstall Microsoft Edge Game Assist --accept-source-agreements"
winget uninstall "Microsoft Edge Game Assist" --accept-source-agreements

echo "winget uninstall Windows Maps --accept-source-agreements"
winget uninstall "Windows Maps" --accept-source-agreements

echo "winget uninstall Windows Clock --accept-source-agreements"
winget uninstall "Windows Clock" --accept-source-agreements

echo "winget uninstall Windows Sound Recorder --accept-source-agreements"
winget uninstall "Windows Sound Recorder" --accept-source-agreements

echo "winget uninstall Outlook for Windows --accept-source-agreements"
winget uninstall "Outlook for Windows" --accept-source-agreements

echo "winget uninstall Mail and Calendar --accept-source-agreements"
winget uninstall "Mail and Calendar" --accept-source-agreements

echo "winget uninstall windows web experience pack --accept-source-agreements"
winget uninstall "windows web experience pack" --accept-source-agreements

echo "winget uninstall Filme & TV  --accept-source-agreements"
winget uninstall "Filme & TV" --accept-source-agreements

echo "winget uninstall Microsoft Kontakte  --accept-source-agreements"
winget uninstall "Microsoft Kontakte" --accept-source-agreements

echo "winget uninstall Mixed Reality-Portal  --accept-source-agreements"
winget uninstall "Mixed Reality-Portal" --accept-source-agreements

echo "winget uninstall Windows-Karten  --accept-source-agreements"
winget uninstall "Windows-Karten" --accept-source-agreements

echo "winget uninstall Print 3D  --accept-source-agreements"
winget uninstall "Print 3D" --accept-source-agreements

echo "Deinstall M365 Companions Files Calendar People"
powershell -NoProfile -Command "Get-AppxPackage Microsoft.M365Companions | Remove-AppxPackage"
rmdir /s /q "%LOCALAPPDATA%\Packages\Microsoft.M365Companions_8wekyb3d8bbwe\LocalState"

echo "Deinstall Intel Bloat"
winget uninstall "Intel(R) Management and Security Status" --accept-source-agreements
powershell -NoProfile -Command "Get-AppxPackage *IntelGraphicsExperience* | Remove-AppxPackage"
powershell -NoProfile -Command "Get-AppxPackage *IntelArcSoftware* | Remove-AppxPackage"
echo. 
echo. 
echo. 
winget list
echo. 
echo. 
echo run as admin press any key to continue admin tasks
echo. 
echo  ==============================
echo Admin Privileges Handling
echo ==============================
echo. 
set doAdminTask=0
set "adminScript=%basicTempDir%\Windows-Admin-Tasks.cmd"


    echo. 
	echo "NOT ADMIN MODE - commands will be written to %adminScript%"
	echo. 
	echo. 	
    echo @echo off > "%adminScript%"
    echo echo Running elevated tasks... >> "%adminScript%"

	echo Enable PING requests
	echo netsh advfirewall firewall add rule name="Allow ICMPv4-In" protocol=icmpv4:8,any dir=in action=allow >> "%adminScript%"

	echo Enable RDP (all Network Profiles)
	echo netsh advfirewall firewall add rule name="Allow RDP-In" protocol=TCP dir=in localport=3389 action=allow profile=any >> "%adminScript%"

	echo sc config w32time start= auto >> "%adminScript%"
	
	echo schtasks /create /tn "daily_Kill_Tool" /tr "C:\Windows\System32\taskkill.exe /IM Tool.exe /F" /sc daily /st 20:00 /ru "SYSTEM" /f >> "%adminScript%"

	echo netsh advfirewall firewall add rule name="Allow RDP" dir=in action=allow protocol=TCP localport=3389 >> "%adminScript%"
	echo reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f >> "%adminScript%"

	echo echo Enable the Performance Boost Menu in PowerPlans >> "%adminScript%"
    echo reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v Attributes /t REG_DWORD /d 2 /f >> "%adminScript%"
   
	echo echo Disable Performance Boost >> "%adminScript%"
	echo powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 0 >> "%adminScript%"
	echo powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 0 >> "%adminScript%"
	echo echo Set MIN Power to 1% >> "%adminScript%"
	echo powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 1 >> "%adminScript%"
	echo powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 1 >> "%adminScript%"
	echo echo Set MAX Power to 1% >> "%adminScript%"
	echo powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 99 >> "%adminScript%"
	echo powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 99 >> "%adminScript%"
	echo echo Disable Monitor Standby and Hibernate >> "%adminScript%"
    echo powercfg.exe -x -monitor-timeout-ac 0 >> "%adminScript%"
    echo powercfg.exe -x -monitor-timeout-dc 0 >> "%adminScript%"
    echo powercfg.exe -x -disk-timeout-ac 0 >> "%adminScript%"
    echo powercfg.exe -x -disk-timeout-dc 0 >> "%adminScript%"
    echo powercfg.exe -x -standby-timeout-ac 0 >> "%adminScript%"
    echo powercfg.exe -x -standby-timeout-dc 0 >> "%adminScript%"
    echo powercfg.exe -x -hibernate-timeout-ac 0 >> "%adminScript%"
    echo powercfg.exe -x -hibernate-timeout-dc 0 >> "%adminScript%"
    echo powercfg.exe /hibernate off >> "%adminScript%"
	echo echo Lid Action do Nothing >> "%adminScript%"
    echo powercfg.exe /setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0 >> "%adminScript%"
    echo powercfg.exe /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0 >> "%adminScript%"
    echo powercfg.exe /S SCHEME_CURRENT >> "%adminScript%"

	echo echo Starting to activate Windows >> "%adminScript%"
	echo pause >> "%adminScript%"
	echo set win11EnterpriseKey=NPPR9-FWDCX-D2C8J-H872K-2YT43 >> "%adminScript%"
	echo set win11ProKey=W269N-WFGWX-YVC9B-4J6C9-T83GX >> "%adminScript%"
	echo set win11HomeKey=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99 >> "%adminScript%"
	echo set KMSServer=kms.digiboy.ir >> "%adminScript%"
	echo slmgr //b /upk >> "%adminScript%"
	echo slmgr //b /cpky >> "%adminScript%"
	echo slmgr //b /ckms >> "%adminScript%"
	echo slmgr //b /ckms >> "%adminScript%"
	echo slmgr //b /skms localhost >> "%adminScript%"
	echo slmgr //b /ipk %%win11EnterpriseKey%% >> "%adminScript%"
	echo slmgr //b /skms %%KMSServer%% >> "%adminScript%"
	echo slmgr //b /ato >> "%adminScript%"

	echo.
	echo done. %time% %date%
	echo. 
	echo Admin script created at %adminScript%
	echo Attempting to run it elevated after pressing any key...
	pause
	powershell -Command "Start-Process '%adminScript%' -Verb RunAs"
	timeout 5 >nul










