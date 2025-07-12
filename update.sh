#!/bin/bash

# Usage: ./update_phicoin.sh 2.0.1

set -e

if [ -z "$1" ]; then
    echo "Error: Please specify a version. Example: ./update_phicoin.sh 2.0.1"
    exit 1
fi

sudo apt update
sudo apt install -y unzip curl

VERSION="$1"
ZIP_URL="https://github.com/PhicoinProject/PhicoinProject/releases/download/${VERSION}/phicoin_${VERSION}_linux.zip"
ZIP_FILE="phicoin_${VERSION}_linux.zip"

echo "Stopping phicoind via CLI..."
./linux/phicoin-cli --datadir=data stop || echo "Warning: phicoind may not be running"

sleep 3

echo "Killing any remaining phicoind processes..."
killall -9 phicoind 2>/dev/null || true

sleep 2

echo "Downloading Phicoin v${VERSION}..."
curl -L -o "${ZIP_FILE}" "${ZIP_URL}"

echo "Unzipping and overwriting into linux/ ..."
unzip -o "${ZIP_FILE}" -d ./

echo "Setting execute permissions..."
chmod +x linux/phicoind linux/phicoin-qt linux/phicoin-cli

echo "Starting new phicoind instance..."
./linux/phicoind --datadir=data &

echo "Update complete and phicoind started."
