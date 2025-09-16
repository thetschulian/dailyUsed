echo ##### Install Lenovo ThinkPad Power Manager on UNIX
echo # Useful for Laptops used as a Lab or Home-Server
echo ######################################################

sudo apt update -y
sudo apt install tlp tlp-rdw -y

echo ##### Starting the Services
sudo systemctl enable tlp --now
sudo systemctl start tlp

echo ##### Checking if Battery is supported / found
sudo tlp-stat 

echo ##### Editing the Config /etc/tlp.conf
echo # Uncomment this Line: START_CHARGE_THRESH_BAT0=80 
echo # Uncomment this Line: STOP_CHARGE_THRESH_BAT0=85
echo # Uncomment this Line: RESTORE_THRESHOLDS_ON_BAT=1

more /etc/tlp.conf | grep "THRESH"

sudo nano /etc/tlp.conf
sudo systemctl restart tlp

echo ##### Check Battery-Level
/etc/update-motd.d/10-battery

echo ##### Disable Hibernate/Sleep/Standby by closing LID
echo # Uncomment this Line: HandleLidSwitch=ignore
echo # Uncomment this Line: HandleLidSwitchDocked=ignore
echo # Uncomment this Line: HandleLidSwitchExternalPower=ignore

sudo nano /etc/systemd/logind.conf
sudo systemctl restart systemd-logind


#### Or on Debian / Proxmox etc
cat /sys/class/power_supply/BAT0/capacity && cat /sys/class/power_supply/BAT0/status

## TODO  16.09.2025
echo A cronjob that runs this script to avoid micro charging at 85% 

## Start content of Anti-Micro-Charging Script
#!/bin/bash
BAT_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)

if [ "$BAT_LEVEL" -ge 85 ]; then
  echo inhibit-charge > /sys/class/power_supply/BAT0/charge_behaviour
elif [ "$BAT_LEVEL" -le 80 ]; then
  echo auto > /sys/class/power_supply/BAT0/charge_behaviour
fi
## END content of Anti-Micro-Charging Script
