@echo off

echo Enables Windows Biometry on Domain devices

::::::START::::::::::::::::::::: CHECK FOR ADMIN PRIVILEGES
echo %DATE% %TIME% Script started.
    NET SESSION >nul 2>&1
    IF %ERRORLEVEL% EQU 0 (
        ECHO "Administrator PRIVILEGES Detected!"
    ) ELSE (
        ECHO "NOT AN ADMIN"
pause
    )
echo.
echo.
::::::END::::::::::::::::::::: CHECK FOR ADMIN PRIVILEGES


reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PassportForWork" /v Enabled /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PassportForWork" /v DisablePostLogonProvisioning /t REG_DWORD /d 0 /f
pause
