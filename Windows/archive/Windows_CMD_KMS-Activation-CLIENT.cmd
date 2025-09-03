@echo off
:kmsLoop

REM ### KMS Server for Activation ###
set KMSServer=kms.digiboy.ir

REM ### Generic Keys ###
set win10EnterpriseKey=NPPR9-FWDCX-D2C8J-H872K-2YT43
set win10ProKey=VK7JG-NPHTM-C97JM-9MPGT-3V66T
set win10HomeKey=YTMG3-N6DKC-DKB77-7M9GH-8HVX

echo slmgr //b /upk
slmgr //b /upk

echo slmgr //b /cpky
slmgr //b /cpky

echo slmgr //b /ckms
slmgr //b /ckms

echo slmgr //b /ckms
slmgr //b /ckms

echo slmgr //b /skms localhost
slmgr //b /skms localhost

echo =========================================
echo.
echo   Verwendeter KMS Server: %KMSServer%
echo   [1] Win Enterprise
echo   [2] Win Pro
echo   [3] Win Home
echo.

SET ASW=0
SET /P ASW=Select: 

if %ASW%==0 goto errorHandler
if %ASW%==1 goto winEnterprise
if %ASW%==2 goto winPro
if %ASW%==3 goto winHome
goto errorHandler

:winEnterprise
echo Activating Win10 Enterprise - %win10EnterpriseKey%
slmgr //b /ipk %win10EnterpriseKey% 
goto continueKMS

:winPro
echo Activating Win10 Pro - %win10ProKey%
slmgr //b /ipk %win10ProKey%
goto continueKMS

:winHome
echo Activating Win10 Home - %win10HomeKey%
slmgr //b /ipk %win10HomeKey%
goto continueKMS

echo =========================================

:continueKMS
ping -n 1 %KMSServer%
echo slmgr //b /skms %KMSServer%
slmgr //b /skms %KMSServer%

echo slmgr //b /ato
slmgr //b /ato

echo Ich habe fertig.
echo Fenster wird in 5 Sekunden geschlossen
timeout 5
exit

:errorHandler
echo Falsche Nummer ausgewählt beginne von vorne...
pause
goto kmsLoop
