# 🔐 Create a New Superuser / Superreader

```bash
configure
# Superuser / Admin
set mgt-config users username-adm password     #ENTER to enter password#
set mgt-config users username-adm permissions role-based superuser yes
set mgt-config users username-adm password-profile #your-predefined-passwordprofile#
# Superreader / Readonly-Admin
set mgt-config users username-ro password     #ENTER to enter password# 
set mgt-config users username-ro permissions role-based superreader yes
set mgt-config users username-ro password-profile #your-predefined-passwordprofile#
```

# 📡 Configure SNMP
```bash
configure
set template #your-firewall-name# 	config  deviceconfig system snmp-setting access-setting version v2c snmp-community-string changeme
set template #your-firewall-name#   config  deviceconfig system service disable-snmp no
```


# 🔁 Test Site-to-Site VPN Connections
```bash
test vpn ike-sa gateway #gatewayname#
test vpn ipsec-sa tunnel #tunnelname:proxyid#

```

# 📶 Ping from Firewall
```bash
ping host 1.1.1.1 
-> pings from the mgmt interface

ping source y.y.y.y host 1.1.1.1
-> y.y.y.y *needs to match* an existing Firewalls Interface IP or Mangement Interface IP
```

# ⚙️ Other Useful CLI Commands
```bash


Set cli pager off
Set cli config-output-format set 
-> this sets the CLI Output to "set" so you can use the commands as a documentation for example
```
