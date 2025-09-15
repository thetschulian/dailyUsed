sudo nano /etc/default/grub

echo find the line GRUB_CMDLINE_LINUX_DEFAULT and add ipv6.disable=1 
echo the line should look like this
echo GRUB_CMDLINE_LINUX_DEFAULT="quiet ipv6.disable=1"

sudo update-grub
