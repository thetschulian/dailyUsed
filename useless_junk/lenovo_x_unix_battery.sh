echo Install Lenovo Think Pad Power Manager on UNIX
sudo apt update -y
sudo apt install tlp tlp-rdw -y

sudo systemctl enable tlp --now
sudo systemctl start tlp

sudo nano /etc/tlp.conf

sudo systemctl restart tlp

echo Check Battery-Level
/etc/update-motd.d/10-battery
