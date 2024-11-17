@echo off
echo ###############################################
echo         DesignSettings WIN10 / 11
echo ###############################################
echo "NICHT ALS ADMIN AUSFUEHREN"
echo "NICHT ALS ADMIN AUSFUEHREN"
echo "NICHT ALS ADMIN AUSFUEHREN"
echo.
pause

echo.
echo ###############################################
echo     Displaying commands as they execute...
echo ###############################################

REM Design Settings Commands (do not require admin)
echo.
echo ########## Setting Registry Values ##########
echo Setting Windows10 Style without advanced options when rightclicking
echo.
echo.

REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /f /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0
echo.
echo Setting LaunchTo registry value...
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v LaunchTo /t REG_DWORD /d 1
echo.
echo Setting TaskbarGlomLevel registry value...
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v TaskbarGlomLevel /t REG_DWORD /d 2
echo.
echo Setting MMTaskbarEnabled registry value...
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v MMTaskbarEnabled /t REG_DWORD /d 1
echo.
echo Setting MMTaskbarGlomLevel registry value...
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v MMTaskbarGlomLevel /t REG_DWORD /d 2
echo.
echo Setting MMTaskbarMode registry value...
REG ADD HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /f /v MMTaskbarMode /t REG_DWORD /d 2
echo.
echo Creating InprocServer32 registry key...
echo Setting HideDesktopIcons registry value...
reg add "HKEY_CURRENT_USER\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve


echo.
echo ###############################################
echo          Prompt for Admin Tasks
echo ###############################################
echo.
set /p runAdmin="Run admin tasks now? (Y/N): "
if /i not "%runAdmin%"=="Y" (
    echo Skipping admin tasks.
	exit
)

echo.
echo ###############################################
echo       Initializing temporary batch file
echo ###############################################
set "AdminScript=%temp%\admin_tasks.bat"
echo CurDate %date%%time% > "%AdminScript%"

REM Dynamically add admin commands below
echo.
echo ########## Adding Admin Commands ##########
echo Adding task scheduler command to temporary batch file:
echo schtasks /create /tn "Kill_ACMP_Task" /tr "C:\Windows\System32\taskkill.exe /IM ACMPConsole.exe /F" /sc daily /st 20:00 /ru "SYSTEM"
echo schtasks /create /tn "Kill_ACMP_Task" /tr "C:\Windows\System32\taskkill.exe /IM ACMPConsole.exe /F" /sc daily /st 20:00 /ru "SYSTEM" >> "%AdminScript%"

REM Add more lines if needed:
REM echo Another command you want to add...
REM echo command >> "%AdminScript%"

echo.
echo ###############################################
echo         Running all admin commands 
echo ###############################################
PowerShell -Command "Start-Process '%AdminScript%' -Verb RunAs"

echo.
echo ########## Cleanup ##########
echo Cleaning up temporary batch file...
del "%AdminScript%"

echo.
echo ###############################################
echo           DONE %date% %time%
echo ###############################################

echo.
echo.

timeout 15
