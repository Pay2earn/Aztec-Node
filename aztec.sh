#!/usr/bin/env bash
set -euo pipefail

CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

echo -e "${CYAN}${BOLD}"
echo "-----------------------------------------------------"
echo "   One Click Setup Aztec Sequencer - Airdrop Insiders"
echo "-----------------------------------------------------"
echo ""

# ====================================================
# Aztec alpha-testnet full node automated installation & startup script
# Version: v0.85.0-alpha-testnet.5
# For Ubuntu/Debian only, requires sudo privileges
# ====================================================

if [ "$(id -u)" -ne 0 ]; then
  echo "⚠️ This script must be run with root (or sudo) privileges."
  exit 1
fi

echo "🔍 Checking for required packages..."
apt-get update -y
apt-get install -y curl ca-certificates gnupg lsb-release software-properties-common

# Docker & Compose
if ! command -v docker &> /dev/null || ! command -v docker-compose &> /dev/null; then
  echo "📦 Docker or Docker Compose not found. Installing..."
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable"
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io
  curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
else
  echo "✅ Docker and Docker Compose are already installed."
fi

# Node.js
if ! command -v node &> /dev/null; then
  echo "📦 Node.js not found. Installing Node.js v18 (LTS)..."
  curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
  apt-get install -y nodejs
else
  echo "✅ Node.js is already installed."
fi

echo "⚙️ Installing Aztec CLI and preparing alpha-testnet..."
curl -sL https://install.aztec.network | bash
export PATH="$HOME/.aztec/bin:$PATH"

if ! command -v aztec-up &> /dev/null; then
  echo "❌ Aztec CLI installation failed."
  exit 1
fi

aztec-up alpha-testnet

echo -e "\n🧠 Instructions for obtaining RPC URLs:"
echo "  - L1 Execution Client (EL) RPC URL: https://dashboard.alchemy.com/"
echo "  - L1 Consensus (CL) RPC URL: https://drpc.org/\n"

read -p "▶️ L1 Execution Client (EL) RPC URL: " ETH_RPC
read -p "▶️ L1 Consensus (CL) RPC URL: " CONS_RPC
read -p "▶️ Blob Sink URL (press Enter if none): " BLOB_URL
read -p "▶️ Validator Private Key: " VALIDATOR_PRIVATE_KEY
read -p "▶️ CoinBase Address: " COINBASE
read -p "▶️ P2P IP Address: " P2P_IP

echo "🌐 Fetching public IP..."
PUBLIC_IP=$(curl -s ipv4.icanhazip.com || echo "127.0.0.1")
echo "    → $PUBLIC_IP"

# Write environment variables
cat > .env <<EOF
ETHEREUM_HOSTS="$ETH_RPC"
L1_CONSENSUS_HOST_URLS="$CONS_RPC"
P2P_IP="$P2P_IP"
VALIDATOR_PRIVATE_KEY="$VALIDATOR_PRIVATE_KEY"
DATA_DIRECTORY="/data"
LOG_LEVEL="debug"
COINBASE="$COINBASE"
EOF

if [ -n "$BLOB_URL" ]; then
  echo "BLOB_SINK_URL=\"$BLOB_URL\"" >> .env
fi

# Entrypoint script
cat > entrypoint.sh <<'EOF'
#!/bin/sh
set -e

CMD="node --no-warnings --max-old-space-size=16384 /usr/src/yarn-project/aztec/dest/bin/index.js start \
  --node \
  --archiver \
  --sequencer \
  --network alpha-testnet \
  --l1-rpc-urls $ETHEREUM_HOSTS \
  --l1-consensus-host-urls $L1_CONSENSUS_HOST_URLS \
  --sequencer.validatorPrivateKey $VALIDATOR_PRIVATE_KEY \
  --sequencer.coinbase $COINBASE \
  --p2p.p2pIp $P2P_IP"

if [ -n "$BLOB_SINK_URL" ]; then
  CMD="$CMD --sequencer.blobSinkUrl $BLOB_SINK_URL"
fi

exec $CMD
EOF

chmod +x entrypoint.sh

# Docker Compose
cat > docker-compose.yml <<EOF
services:
  node:
    image: aztecprotocol/aztec:alpha-testnet
    ports:
      - "8080:8080"
      - "40400:40400"
      - "40400:40400/udp"
    environment:
      - ETHEREUM_HOSTS=\${ETHEREUM_HOSTS}
      - L1_CONSENSUS_HOST_URLS=\${L1_CONSENSUS_HOST_URLS}
      - P2P_IP=\${P2P_IP}
      - VALIDATOR_PRIVATE_KEY=\${VALIDATOR_PRIVATE_KEY}
      - DATA_DIRECTORY=\${DATA_DIRECTORY}
      - LOG_LEVEL=\${LOG_LEVEL}
      - COINBASE=\${COINBASE}
      - BLOB_SINK_URL=\${BLOB_SINK_URL:-}
    volumes:
      - ./data:/data
      - ./entrypoint.sh:/entrypoint.sh
    entrypoint: ["/bin/sh", "/entrypoint.sh"]
EOF

mkdir -p data

echo "🚀 Starting Aztec full node..."
docker-compose up -d

echo -e "\n✅ ${BOLD}Installation and startup completed!${RESET}"
echo "   - Check logs: docker-compose logs -f"
echo "   - Data directory: $(pwd)/data"
