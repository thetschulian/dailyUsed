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

# Create Objects

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

# ⚙️ Other Useful CLI Commands
```bash
set cli pager off
set cli config-output-format set
```
   -> this sets the CLI Output to "set" so you can use the commands as a documentation 

---

The needed Infos about Objects are named in this Markdown which is going to be used to create a webapp (html/js) for Palo Alto.
I should be able to enter a list of IPs or FQDNs and a "destination"  address group as a single field. 
The Name of the FQDN object should contain the Domain by default, add another textbox for the alternate name which is nevertheless needed for IP objects as a prefix. lets assum in that case the prefix for those iPs should be AV-Server
Example 192.168.0.1 should get the name S_AV-Server_192.168.0.1
Example google.com should get the Name S_google.com as long as the alternate name field is empty. if its set the name should look like S_AV-Server_google.com


And be carefull, any of the objectname (address or address group) should NEVER exceed 62 characters due to palo character limits.
Always think about the Prefixes S_ and S_HG_ 

The output should be rendered in realtime so if i change something in my list or the prefix fields the set commands created by that app will automatically being updated i think its possible with java script
