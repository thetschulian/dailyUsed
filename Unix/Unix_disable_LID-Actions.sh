nano /etc/systemd/logind.conf

echo Find and uncomment HandleLidSwitch=ignore
echo add those lines 
echo HandleLidSwitchExternalPower=ignore
echo HandleLidSwitchDocked=ignore

systemctl restart systemd-logind
