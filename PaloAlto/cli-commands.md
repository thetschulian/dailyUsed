# 🔐 Create a New Superuser / Superreader

```bash
configure
# Create a Superuser (Admin)
set mgt-config users <username-adm> password     <press ENTER to enter password>
set mgt-config users <username-adm> permissions role-based superuser yes
set mgt-config users <username-adm> password-profile <your-predefined-passwordprofile>

# Create a Superreader (Readonly Admin)
set mgt-config users <username-ro> password     <press ENTER to enter password>
set mgt-config users <username-ro> permissions role-based superreader yes
set mgt-config users <username-ro> password-profile <your-predefined-passwordprofile>
```

# 📡 Configure SNMP
```bash
configure
set template <your-firewall-name> config deviceconfig system snmp-setting access-setting version v2c snmp-community-string <changeme>
set template <your-firewall-name> config deviceconfig system service disable-snmp no
```

# 📡 Configure (external) Management Profile for Permitted IP
and enable https, ssh and ping for those
```bash
configure

set template <your-firewall-name> config  network profiles interface-management-profile Outside_Management permitted-ip 62.1.2.3/27
set template <your-firewall-name> config  network profiles interface-management-profile Outside_Management permitted-ip 62.2.2.236/32
set template <your-firewall-name> config  network profiles interface-management-profile Outside_Management permitted-ip 212.1.2.3/28
set template <your-firewall-name> config  network profiles interface-management-profile Outside_Management https yes
set template <your-firewall-name> config  network profiles interface-management-profile Outside_Management ssh yes
set template <your-firewall-name> config  network profiles interface-management-profile Outside_Management ping yes

# Now attach the Profile to your desired interface
set template <your-firewall-name> config  network interface aggregate-ethernet ae1 layer3 units ae1.655 interface-management-profile Outside_Management



```


# 🔁 Test Site-to-Site VPN Connections
```bash
test vpn ike-sa gateway <gatewayname>
test vpn ipsec-sa tunnel <tunnelname:proxyid>

```

# 📶 Ping from Firewall
```bash
ping host 1.1.1.1
```
-> pings 1.1.1.1 from the mgmt interface
   
```bash
ping source y.y.y.y host 1.1.1.1
```
-> the source y.y.y.y needs to match an existing Firewalls Interface IP or Mangement Interface IP to ping 1.1.1.1

# 🥑 Create Objects

```bash

configure

#Create Object - Tag
set shared tag S_TagName color color32
set shared tag S_TagName comments "description for the tag"

#Create Object - Single HOST FQDN
set shared address S_PC-CTX-IT26 fqdn PC-CTX-IT26.domain.de
set shared address S_PC-CTX-IT26 description "Name of Mainuser or Admin"
set shared address S_PC-CTX-IT26 tag S_TagName

#Create Object - Single HOST IP-Address
set shared address S_svr-rproxy10 ip-netmask 192.168.1.2/32
set shared address S_svr-rproxy10 description "Reverse Proxy Node 1"
set shared address S_svr-rproxy10 tag S_TagName
   
#Create Object - Fill a Hostgroup/Addressgroup with Address Objects
set shared address-group S_HG_AddressGroupNAME static [ S_PC-CTX-IT24 S_PC-CTX-IT26 ]
set shared address-group S_HG_AddressGroupNAME description "Hostgroup for example "
set shared address-group S_HG_AddressGroupNAME tag S_TagName
```
> Prefix S_ means its a shared object which all firewalls which are connected to panorama can use
> HG means HostGroup and should be used to make a difference between single address objects and address group objects!! 


# ↩️ Recover  Devices to Panorama


1. Start on your Panorama 
```bash
request authkey add devtype <fw_or_lc> count <device_count> lifetime <key_lifetime> name <key_name> serial <device_SN>

request authkey add devtype fw count 15 lifetime 30 name My-15-Firewalls
request authkey list My-15-Firewalls
```
   -> The devtype and serial arguments are optional. Omit these two arguments to make a general use device registration authentication key that is not specific to a device type or device serial number.

2. Login to your first local Firewall
```bash
request sc3 reset
debug software restart process management-server
show system info | match serial
```
   -> This removes the current binding between firewall and panorama

3. Back on on Panorama  
```bash
clear device-status deviceid ?  #Shows all currently connected devices but better use the Serial you get in Step 2 !
clear device-status deviceid 012345678901
clear device-status deviceid 012345678902
clear device-status deviceid 012345678903


```
   -> Clears the binded local Firewall out of panorama. Make sure you use the correct Serial of Step 2 !!

4. Back to your first local Firewall  
```bash
request authkey set <enter the Authkey from Step 1>

```
   -> After entering the Authkey from Step 1, your Firewall should auto-commit (see GUI)




# ⚙️ Other Useful CLI Commands
```bash
set cli pager off
set cli config-output-format set
```
   -> this sets the CLI Output to "set" so you can use the commands as a documentation 

---
