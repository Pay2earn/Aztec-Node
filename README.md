# Aztec Sequencer Setup - Alpha Testnet

This repository contains an automated script for setting up and running an Aztec Sequencer node on the Alpha Testnet.  
The script streamlines the installation process, making it accessible for both newcomers and experienced blockchain developers.

---

## 📦 Features

- ✅ Install Docker and Docker Compose (if not already installed)
- ✅ Install Node.js (LTS version, e.g., 18.x)
- ✅ Install Aztec CLI
- ✅ Configure the Aztec Alpha Testnet environment
- ✅ Prompt for RPC URLs and validator private key
- ✅ Automatically start the Aztec Sequencer node using Docker

---

## 🖥️ Requirements

- Ubuntu/Debian-based Linux OS
- Root or sudo privileges
- Internet connection
- L1 Execution Client (EL) RPC URL
- L1 Consensus Client (CL) RPC URL
- Validator Private Key
- *(Optional)* Blob Sink URL

---

## ⚡ Quick Start

* Clone repo
```bash
git clone https://github.com/Pay2earn/Aztec-Node.git
cd Aztec-Node
```

* Give permission to run the script
```bash
chmod +x aztec.sh
```

* Open a screen to run it in background
```bash
screen -S aztec
```

* Run with sudo
```bash
sudo ./aztec.sh
```

Then follow the interactive prompts to input your RPC URLs and validator key.

🔧 How to Obtain RPC URLs

🔹 L1 Execution Client (EL) RPC – Alchemy

1. Go to: https://dashboard.alchemy.com/

2. Create a new app:

- Select Ethereum chain

- Choose Sepolia as the network

- Name your app (e.g., Aztec Sequencer)

Click "View Key"

Copy the HTTPS RPC URL, e.g.:
https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY

🔸 L1 Consensus Client (CL) RPC – DRPC
1. Go to: https://drpc.org/

2. Create an API key:

- Select Sepolia network

- Name it (e.g., Aztec Sequencer)

Copy the HTTPS RPC URL, e.g.:
https://lb.drpc.org/ogrpc?network=sepolia&dkey=YOUR_API_KEY

---

## 🌐 Alternative RPC Providers
You may also use:

[Infura](https://infura.io/)

[QuickNode](https://www.quicknode.com/)

[Ankr](https://www.ankr.com/)

[Chainstack](https://chainstack.com/)

Follow the provider’s process to get Sepolia RPC URLs.

---

## 📊 Checking Node Status
```bash
docker-compose logs -f
```
Your node data will be stored in the ./data directory created alongside the script.

---

## 🧰 Troubleshooting
Verify Docker is installed:
```bash
docker --version
docker-compose --version
```
Check if your RPC URLs are correct and functional

Ensure your server meets the recommended specs:

CPU: ≥ 8 cores

RAM: ≥ 16 GB

Disk: ≥ 100 GB

Upload speed: ≥ 25 Mbps

Open necessary ports in your firewall (e.g., 8080, 40400)

---

## 📚 Resources

📖 [Aztec Documentation](https://docs.aztec.network/)

💬 [Aztec Discord](https://discord.gg/aztec)

🗣️ [Aztec Forum](https://forum.aztec.network/)

---

## 🛠 Version Info
Script version: v0.85.0-alpha-testnet.5

Compatible Aztec Protocol version: 0.85.0-alpha-testnet.5

---

## ⚠️ Disclaimer
This script is designed for Alpha Testnet only. It is not suitable for production use.
Use at your own risk.

---

## ⚖️ License
MIT License

---

## 🔄 Reset Node Completely

To stop and remove your Aztec node along with all related data:

```bash
docker compose down -v --remove-orphans
sudo rm -rf ./data
```
This will completely wipe your node’s state and storage, allowing you to start fresh.







