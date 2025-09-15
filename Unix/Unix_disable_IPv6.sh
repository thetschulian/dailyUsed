sudo nano /etc/default/grub

echo find the line GRUB_CMDLINE_LINUX_DEFAULT and add ipv6.disable=1 
echo the line should look like this
echo GRUB_CMDLINE_LINUX_DEFAULT="quiet ipv6.disable=1"

sudo update-grub


echo debian
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.conf.lo.disable_ipv6=1

echo ubuntu
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
