# ============================
#  BASELINE: Block all inbound
# ============================
Set-NetFirewallProfile -Profile Domain,Private,Public -DefaultInboundAction Block

# ============================
#  ALLOW RDP ONLY FROM 192.168.1.1
# ============================
New-NetFirewallRule -DisplayName "Allow RDP from 192.168.1.1" `
  -Direction Inbound -Protocol TCP -LocalPort 3389 `
  -RemoteAddress 192.168.1.1/32 -Action Allow

# ============================
#  BLOCK RDP FROM EVERYONE ELSE
# ============================
New-NetFirewallRule -DisplayName "Block RDP from all others" `
  -Direction Inbound -Protocol TCP -LocalPort 3389 `
  -RemoteAddress Any -Action Block

# ============================
#  BLOCK SMB (445,139,137,138)
# ============================
New-NetFirewallRule -DisplayName "Block SMB TCP" `
  -Direction Inbound -Protocol TCP -LocalPort 445,139 `
  -RemoteAddress Any -Action Block

New-NetFirewallRule -DisplayName "Block SMB UDP" `
  -Direction Inbound -Protocol UDP -LocalPort 137,138 `
  -RemoteAddress Any -Action Block

# ============================
#  BLOCK WINRM (5985,5986)
# ============================
New-NetFirewallRule -DisplayName "Block WinRM" `
  -Direction Inbound -Protocol TCP -LocalPort 5985,5986 `
  -RemoteAddress Any -Action Block

# ============================
#  BLOCK WMI/DCOM/RPC (135 + dynamic RPC)
# ============================
New-NetFirewallRule -DisplayName "Block RPC Endpoint Mapper" `
  -Direction Inbound -Protocol TCP -LocalPort 135 `
  -RemoteAddress Any -Action Block

# Optional: block dynamic RPC ports (Windows uses 49152–65535)
New-NetFirewallRule -DisplayName "Block RPC Dynamic Ports" `
  -Direction Inbound -Protocol TCP -LocalPort 49152-65535 `
  -RemoteAddress Any -Action Block

# ============================
#  BLOCK REMOTE EVENT LOG (5985/5986 already covered)
# ============================

# ============================
#  BLOCK FILE/PRINTER DISCOVERY
# ============================
# SSDP (1900)
New-NetFirewallRule -DisplayName "Block SSDP Discovery" `
  -Direction Inbound -Protocol UDP -LocalPort 1900 `
  -RemoteAddress Any -Action Block

# WS-Discovery (3702)
New-NetFirewallRule -DisplayName "Block WS-Discovery" `
  -Direction Inbound -Protocol UDP -LocalPort 3702 `
  -RemoteAddress Any -Action Block

# LLMNR (5355)
New-NetFirewallRule -DisplayName "Block LLMNR" `
  -Direction Inbound -Protocol UDP -LocalPort 5355 `
  -RemoteAddress Any -Action Block
