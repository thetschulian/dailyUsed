# 🔐 OTP_QR_to_TEXT

A lightweight tool to convert any OTP (One-Time Password) QR code into plain text secrets.

## ✨ Features

- Decode OTP QR codes into readable secrets
- Supports Google Authenticator exports
- Easily migrate to other OTP tools like Bitwarden, Reiner SCT, and more
- Everything runs **locally** on your computer — no data is sent externally

## ⚠️ Disclaimer

This tool is provided **as-is**, without any guarantees or warranties. All processing is performed locally on your machine, and you are solely responsible for how you use the extracted data.

> **Important Notes:**
> - I am **not responsible** for any included scripts, JavaScript code, or third-party components referenced in this project.
> - Always **verify** that the newly generated OTP codes match the originals **before deleting** your existing authenticator entries — especially when migrating from Google Authenticator.
> - Use this tool at your own risk. Improper handling of OTP secrets may result in permanent loss of access to your accounts.

## 🛠️ Usage

1. Download the repository.
2. Open the `index.html` file with your favourite browser.
3. Upload an OTP QR code — the tool will extract the secret key in plain text format.
4. Optional: Import the extracted secret into your preferred OTP manager.

> If errors occur, try cropping the image so that only the QR code remains visible in the screenshot.

---

Feel free to contribute or raise issues via the GitHub repo. Happy migrating!
