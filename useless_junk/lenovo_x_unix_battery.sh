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
