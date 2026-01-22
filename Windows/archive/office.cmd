echo slmgr //b /skms localhost
slmgr //b /skms localhost

echo slmgr //b /skms kms.digiboy.ir
slmgr //b /skms kms.digiboy.ir

:32bit
cls
echo setup.exe /configure Konfiguration32bit.xml
echo Soll der Befehl nun ausgefuehrt werden? (weiter mit beliebiger Taste)
pause >nul
setup.exe /configure Konfiguration32bit.xml
echo Licence Infos 32bit
cscript "C:\Program Files (x86)\Microsoft Office\Office16\OSPP.VBS" /dstatus
echo Activate Office
cscript "C:\Program Files (x86)\Microsoft Office\Office16\OSPP.VBS" /act
goto END

:64bit
cls
echo setup.exe /configure Konfiguration64bit.xml
echo Soll der Befehl nun ausgefuehrt werden? (weiter mit beliebiger Taste)
pause >nul
setup.exe /configure Konfiguration64bit.xml
echo Licence Infos 64bit
cscript "C:\Program Files\Microsoft Office\Office16\OSPP.VBS" /dstatus
echo Activate Office
cscript "C:\Program Files\Microsoft Office\Office16\OSPP.VBS" /act

