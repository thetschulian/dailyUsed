echo ##### Install Lenovo Think Pad Power Manager on UNIX
sudo apt update -y
sudo apt install tlp tlp-rdw -y

sudo systemctl enable tlp --now
sudo systemctl start tlp




echo ##### Checking if Battery is supported / found
sudo tlp-stat 

echo ##### Editing the Config /etc/tlp.conf
echo Uncomment this Line: START_CHARGE_THRESH_BAT0=80 
echo Uncomment this Line: STOP_CHARGE_THRESH_BAT0=85

sudo nano /etc/tlp.conf

sudo systemctl restart tlp

echo ##### Check Battery-Level
/etc/update-motd.d/10-battery
