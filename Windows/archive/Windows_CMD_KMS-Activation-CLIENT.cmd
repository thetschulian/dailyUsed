@echo off
:kmsLoop

REM ### KMS Server for Activation ###
set KMSServer=kms.digiboy.ir

		REM ### Generic Keys ###
		set win10EnterpriseKey=NPPR9-FWDCX-D2C8J-H872K-2YT43
		set win10ProKey=W269N-WFGWX-YVC9B-4J6C9-T83GX
		set win10HomeKey=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99

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
echo   [1] Win11 Enterprise
echo   [2] Win11 Pro
echo   [3] Win11 Home
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



:errorHandler
echo Falsche Nummer ausgewählt beginne von vorne...
pause
goto kmsLoop
