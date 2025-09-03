@echo off

REM WinSVR Datacenter Key GENERIC KEY
set winKey=WMDGN-G9PQG-XVVXX-R3X43-63DFG

echo DISM /online /Set-Edition:ServerDatacenter /ProductKey:%winKey% /AcceptEula


echo slmgr //b /upk
slmgr  /upk

echo slmgr //b /cpky
slmgr /cpky

echo slmgr //b /ckms
slmgr /ckms

echo slmgr //b /ckms
slmgr  /ckms

echo slmgr //b /skms localhost
slmgr  /skms localhost

echo slmgr //b /ipk %winKey% (Win SVR Datacenter)
slmgr  /ipk %winKey%

echo slmgr //b /skms kms.digiboy.ir
slmgr  /skms kms.digiboy.ir

echo slmgr //b /ato
slmgr  /ato

echo DONE!

pause
