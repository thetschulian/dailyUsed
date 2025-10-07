@echo off
::::: Last Edited: 29.09.2025
echo %DATE% %TIME% Script started.
echo Run this in CMD only - powershell will cause errors
pause

mkdir C:\temp
echo Download newest Version to C:\temp
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/thetschulian/dailyUsed/main/Windows/Windows-Usr-Basics.cmd' -OutFile 'C:\temp\Windows-Usr-Basics.cmd'"

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
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v MMTaskbarEnabled /t REG_DWORD /d 1
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v MMTaskbarGlomLevel /t REG_DWORD /d 2
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v MMTaskbarMode /t REG_DWORD /d 2
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v TaskbarDa /t REG_DWORD /d 0 

echo Disable the Search Box
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search /f /v SearchBoxTaskbarMode /t REG_DWORD /d 0 

echo Show My Computer on Desktop
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f

echo Taskmaanger Default Register performance
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\TaskManager /f /v StartUpTab /t REG_DWORD /d 1 

echo Add END TASK to Taskbar
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings /f /v TaskbarEndTask /t REG_DWORD /d 1 

Echo Disable SHARE Button on Taskbar Previews
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSn /t REG_DWORD /d 0 /f

rem Echo Install Powertoys
rem  winget install Microsoft.PowerToys --source winget

rem echo Install Lenovo Commercial Vantage
rem winget install "Lenovo Commercial Vantage" --source=msstore --accept-package-agreements --accept-source-agreements

Echo debloat windows
winget uninstall "Microsoft 365 Copilot" --accept-source-agreements
winget uninstall "Copilot" --accept-source-agreements
winget uninstall "Feedback Hub" --accept-source-agreements
winget uninstall "Game Bar" --accept-source-agreements
::winget uninstall "Paint" --accept-source-agreements
winget uninstall "Cortana" --accept-source-agreements
winget uninstall "News" --accept-source-agreements
winget uninstall "Movies & TV " --accept-source-agreements
winget uninstall "Power Automate" --accept-source-agreements
winget uninstall "Microsoft Bing" --accept-source-agreements
winget uninstall "Microsoft Tips" --accept-source-agreements
winget uninstall "Microsoft People" --accept-source-agreements
winget uninstall "Microsoft Photos" --accept-source-agreements
winget uninstall "Microsoft Sticky Notes" --accept-source-agreements
winget uninstall "Microsoft Clipchamp" --accept-source-agreements

winget uninstall "Phone Link" --accept-source-agreements
winget uninstall "Smartphone Link" --accept-source-agreements
winget uninstall "Windows Media Player" --accept-source-agreements
winget uninstall "Microsoft To Do" --accept-source-agreements
winget uninstall "Solitaire & Casual Games" --accept-source-agreements
winget uninstall "MSN Weather" --accept-source-agreements

winget uninstall "Xbox TCUI" --accept-source-agreements
winget uninstall "Xbox" --accept-source-agreements
winget uninstall "Xbox Game Bar Plugin" --accept-source-agreements
winget uninstall "Xbox Game Speech Window" --accept-source-agreements
winget uninstall "Xbox Identity Provider" --accept-source-agreements
winget uninstall "Quick Assist" --accept-source-agreements
winget uninstall "Game Speech Window" --accept-source-agreements
winget uninstall "Get Help" --accept-source-agreements
winget uninstall "Microsoft Edge Game Assist" --accept-source-agreements

winget uninstall "Windows Maps" --accept-source-agreements
winget uninstall "Windows Clock" --accept-source-agreements
winget uninstall "Windows Sound Recorder" --accept-source-agreements
winget uninstall "Outlook for Windows" --accept-source-agreements
winget uninstall "Mail and Calendar" --accept-source-agreements
winget uninstall "windows web experience pack" --accept-source-agreements

winget list

echo run as admin press any key to continue admin tasks

pause 

::::::START::::::::::::::::::::: CHECK FOR ADMIN PRIVILEGES

    NET SESSION >nul 2>&1
    IF %ERRORLEVEL% EQU 0 (
    
	ECHO "Administrator PRIVILEGES Detected!"
	echo this should be moved to a own script and run elevated. 
	echo Launching admin tasks...
	echo powershell -Command "Start-Process 'C:\temp\Windows-Admin-Tasks.cmd' -Verb RunAs"

		echo CPU Performance Boost (as Local ADMIN)
			reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v Attributes /t REG_DWORD /d 2 /f
		
		echo disable auto pair notifications of bluetooth devices
		   reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Bluetooth\SwiftPair" /v QuickPair /t REG_DWORD /d 0 /f
		
		
		 echo  Kill A Scheduled Task (as Local Admin)
		schtasks /create /tn "daily_Kill_Tool" /tr "C:\Windows\System32\taskkill.exe /IM Tool.exe /F" /sc daily /st 20:00 /ru "SYSTEM"
		
		
		echo disable monitor timeout, hibernate and standby as admin
		
		powercfg.exe -x -monitor-timeout-ac 0
		powercfg.exe -x -monitor-timeout-dc 0
		powercfg.exe -x -disk-timeout-ac 0
		powercfg.exe -x -disk-timeout-dc 0
		powercfg.exe -x -standby-timeout-ac 0
		powercfg.exe -x -standby-timeout-dc 0
		powercfg.exe -x -hibernate-timeout-ac 0
		powercfg.exe -x -hibernate-timeout-dc 0
		
		REM --- Disable hibernation and Fast Startup ---
		powercfg.exe /hibernate off
		
		REM --- Set lid close action to 'Do nothing' ---
		powercfg.exe /setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0
		powercfg.exe /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0
		
		REM --- Apply the changes ---
		powercfg.exe /S SCHEME_CURRENT


    ) ELSE (
        ECHO "NOT AN ADMIN"
		echo creating the admin script now

		rem Create the admin script dynamically
		set "adminScript=%TEMP%\Windows-Admin-Tasks.cmd"
		echo @echo off > "%adminScript%"
		echo echo Running elevated tasks... >> "%adminScript%"
		echo reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v Attributes /t REG_DWORD /d 2 /f >> "%adminScript%"
		echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Bluetooth\SwiftPair" /v QuickPair /t REG_DWORD /d 0 /f >> "%adminScript%"
		echo schtasks /create /tn "daily_Kill_Tool" /tr "C:\Windows\System32\taskkill.exe /IM Tool.exe /F" /sc daily /st 20:00 /ru "SYSTEM" >> "%adminScript%"
		echo powercfg.exe -x -monitor-timeout-ac 0 >> "%adminScript%"
		echo powercfg.exe -x -monitor-timeout-dc 0 >> "%adminScript%"
		echo powercfg.exe -x -disk-timeout-ac 0 >> "%adminScript%"
		echo powercfg.exe -x -disk-timeout-dc 0 >> "%adminScript%"
		echo powercfg.exe -x -standby-timeout-ac 0 >> "%adminScript%"
		echo powercfg.exe -x -standby-timeout-dc 0 >> "%adminScript%"
		echo powercfg.exe -x -hibernate-timeout-ac 0 >> "%adminScript%"
		echo powercfg.exe -x -hibernate-timeout-dc 0 >> "%adminScript%"
		echo powercfg.exe /hibernate off >> "%adminScript%"
		echo powercfg.exe /setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0 >> "%adminScript%"
		echo powercfg.exe /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0 >> "%adminScript%"
		echo powercfg.exe /S SCHEME_CURRENT >> "%adminScript%"
		
		rem Launch the admin script with elevation
		powershell -Command "Start-Process '%TEMP%\Windows-Admin-Tasks.cmd' -Verb RunAs"



pause
    )
echo.
echo.
::::::END::::::::::::::::::::: CHECK FOR ADMIN PRIVILEGES





