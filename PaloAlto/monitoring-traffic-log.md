# 🛡️ Palo Alto Traffic Log Filter Cheatsheet (GUI)

## 🧠 Grundprinzipien

- Die Filter-Syntax basiert auf logischen Ausdrücken wie `and`, `or`, `eq`, `in`, `contains`, etc.
- **Klammern sind Pflicht**, wenn du mehrere Bedingungen kombinierst, damit Palo Alto die Reihenfolge korrekt auswertet.
  - Beispiel:
    ```text
    (addr.src in '192.168.0.10' and port.dst eq 443) or (addr.dst in '192.168.1.20' and port.dst eq 80)
    ```
    → Zeigt HTTPS von 192.168.0.10 **oder** HTTP zu 192.168.1.20

---

## 🔍 IP-Filter

```text
addr.src in '192.168.0.10' and addr.dst in '192.168.1.20'
→ Zeigt alle Verbindungen von Quelle 192.168.0.10 zu Ziel 192.168.1.20

addr in '192.168.2.123'
→ Zeigt alle eingehenden und ausgehenden Verbindungen dieser IP

addr.src in '192.168.2.0/24'
→ Zeigt alle Verbindungen aus dem 192.168.2.0er Netz

addr.dst in '192.168.0.0/16'
→ Zeigt alle Verbindungen zu Zielen im 192.168.x.x Netz


```
## 🌐 Port- und Protokollfilter
```text

port.dst eq 443
→ Zielport ist HTTPS

port.src eq 22
→ Quellport ist SSH

proto eq 6
→ TCP (6 = TCP, 17 = UDP, 1 = ICMP)

proto eq 17
→ UDP-Verbindungen

proto eq 1
→ ICMP (Ping)
```
