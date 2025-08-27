# 🔐 OTP_QR_to_TEXT

A lightweight tool to convert any OTP (One-Time Password) QR code into plain text secrets.

## ✨ Features

- Decode OTP QR codes into readable secrets
- Supports Google Authenticator exports
- Easily migrate to other OTP tools like Bitwarden, Reiner SCT, etc.
- Everything runs **locally** on your computer — no data is sent externally

## ⚠️ Disclaimer

This tool is provided **as-is**, without any guarantees or warranties. While all processing is done locally on your machine, you are solely responsible for how you use the extracted data.

> **Important Notes:**
> - I am **not responsible** for any scripts, code snippets, or third-party components included or referenced in this project.
> - Always **verify** that the newly generated OTP codes match the originals **before deleting** your existing authenticator entries — especially with Google Authenticator exports.
> - Use this tool at your own risk. Misuse or incorrect handling of OTP secrets may result in loss of access to critical accounts.

## 🛠️ Usage

Simply scan or upload an OTP QR code and the tool will extract the secret key in plain text format. You can then import it into your preferred OTP manager.

---

Feel free to contribute or raise issues via the GitHub repo. Happy migrating!
