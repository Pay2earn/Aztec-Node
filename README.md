## ⚠️ Credits

This script is adapted from the work of [0xmoei](https://github.com/0xmoei/aztec-network) and [airdropinsiders](https://github.com/airdropinsiders/Aztec-Node).  
All original rights and acknowledgements belong to the respective authors.

---

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

[BlockPI](https://blockpi.io/)

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
sudo rm -rf /root/Aztec-Node/data
```
This will completely wipe your node’s state and storage, allowing you to start fresh.

---

## 🔐 Get Role on Discord
Go to the discord channel :[operators| start-here](https://discord.com/channels/1144692727120937080/1367196595866828982/1367323893324582954) and follow the prompts, You can continue the guide with my commands if you need help.

![image](https://github.com/user-attachments/assets/90e9d34e-724b-481a-b41f-69b1eb4c9f65)

**Step 1: Get the latest proven block number:**
```bash
curl -s -X POST -H 'Content-Type: application/json' \
-d '{"jsonrpc":"2.0","method":"node_getL2Tips","params":[],"id":67}' \
http://localhost:8080 | jq -r ".result.proven.number"
```
* Save this block number for the next steps
* Example output: 20905

**Step 2: Generate your sync proof**
```bash
curl -s -X POST -H 'Content-Type: application/json' \
-d '{"jsonrpc":"2.0","method":"node_getArchiveSiblingPath","params":["BLOCK_NUMBER","BLOCK_NUMBER"],"id":67}' \
http://localhost:8080 | jq -r ".result"
```
* Replace 2x `BLOCK_NUMBER` with your number

**Step 3: Register with Discord**
* Type the following command in this Discord server: `/operator start`
* After typing the command, Discord will display option fields that look like this:
* `address`:            Your validator address (Ethereum Address)
* `block-number`:      Block number for verification (Block number from Step 1)
* `proof`:             Your sync proof (base64 string from Step 2)

Then you'll get your `Apprentice` Role

![image](https://github.com/user-attachments/assets/2ae9ff7c-59ba-43ec-9a23-76ef8ccb997c)

---

## 📝 Register as Validator
```bash
aztec add-l1-validator \
  --l1-rpc-urls RPC_URL \
  --private-key your-private-key \
  --attester your-validator-address \
  --proposer-eoa your-validator-address \
  --staking-asset-handler 0xF739D03e98e23A7B65940848aBA8921fF3bAc4b2 \
  --l1-chain-id 11155111
```
Replace `RPC_URL`, `your-validator-address` & 2x `your-validator-address`, then proceed

* Note that there's a daily quota of 10 validator registration per day, if you get error, try again tommorrow.

---

## 🙏 Credits

Parts of this script are based on public repositories from:

- [0xmoei](https://github.com/0xmoei/aztec-network)
- [airdropinsiders](https://github.com/airdropinsiders/Aztec-Node)







