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
## 🔥 Action & Regel-Filter
```text
action eq allow
→ Erlaubte Verbindungen

action eq deny
→ Geblockte Verbindungen

rule eq 'Internet-Out'
→ Logs, die durch Regel "Internet-Out" verarbeitet wurden

(rule contains 'VPN') and action eq allow
→ Erlaubte Verbindungen über Regeln mit "VPN" im Namen
```
## 👤 User & App Filter
```text
user.src eq 'j.smith@domain.local'
→ Verbindungen vom Benutzer j.smith

app eq 'web-browsing'
→ App-ID ist Web-Browsing

app contains 'ssl'
→ Alle SSL-basierten Anwendungen
```
## 📅 Zeitfilter
```text
receive_time geq '2025/10/07 08:00:00' and receive_time leq '2025/10/07 10:00:00'
→ Logs zwischen 08:00 und 10:00 Uhr am 07.10.2025
```
## 🧰 Kombinierte Filter mit Klammern
```text
(addr.src in '192.168.0.10' and port.dst eq 443) and action eq allow
→ HTTPS von 192.168.0.10, erlaubt

(addr in '192.168.2.0/24' and app eq 'ssl') or (addr.dst in '192.168.1.20' and port.dst eq 80)
→ SSL aus dem Netz **oder** HTTP zu 192.168.1.20

((addr.src in '192.168.0.10' or addr.dst in '192.168.0.10') and action eq deny)
→ Alle geblockten Verbindungen mit Beteiligung von 192.168.0.10

((rule eq 'Internet-Out' or rule eq 'VPN-Allow') and port.dst eq 443)
→ HTTPS-Verbindungen über Internet- oder VPN-Regeln

((addr.src in '192.168.2.0/24') and (app eq 'ssl' or app eq 'web-browsing') and action eq allow)
→ Erlaubte SSL/Web-Browsing-Verbindungen aus dem 192.168.2.0/24 Netz
```
