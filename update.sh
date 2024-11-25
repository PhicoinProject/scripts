#!/bin/bash

# Define variables
PHICOIN_URL="https://github.com/PhicoinProject/PhicoinProject/releases/download/1.1.1.1/linux.tar"
DOWNLOAD_FILE="linux.tar"
EXTRACT_DIR="./linux"
DATA_DIR="./data"
EXECUTABLE="$EXTRACT_DIR/phicoind"
CLI="$EXTRACT_DIR/phicoin-cli"
QT="$EXTRACT_DIR/phicoin-qt"

# Step 1: Kill all running phicoind processes
echo "Stopping all running phicoind processes..."
pkill -f phicoind
if [ $? -eq 0 ]; then
  echo "Successfully killed phicoind processes."
else
  echo "No phicoind processes found."
fi

# Step 2: Remove old executables
echo "Removing old Phicoin executables..."
rm -f ./phicoind ./phicoin-cli ./phicoin-qt
if [ $? -eq 0 ]; then
  echo "Old executables removed successfully."
else
  echo "Error removing old executables. Exiting."
  exit 1
fi

# Step 3: Download the latest release
echo "Downloading the latest phicoind release from $PHICOIN_URL..."
curl -L -o "$DOWNLOAD_FILE" "$PHICOIN_URL"
if [ $? -ne 0 ]; then
  echo "Error: Failed to download phicoind. Exiting."
  exit 1
fi

# Step 4: Extract the downloaded tarball
echo "Extracting phicoind..."
tar -xvf "$DOWNLOAD_FILE"
if [ $? -ne 0 ]; then
  echo "Error: Failed to extract phicoind. Exiting."
  exit 1
fi

# Step 5: Move new executables to current directory
echo "Moving new executables to current directory..."
mv "$EXECUTABLE" ./phicoind
mv "$CLI" ./phicoin-cli
mv "$QT" ./phicoin-qt

# Step 6: Grant execute permissions
echo "Granting execute permissions to new executables..."
chmod +x ./phicoind ./phicoin-cli ./phicoin-qt
if [ $? -ne 0 ]; then
  echo "Error: Failed to set execute permissions. Exiting."
  exit 1
fi

# Step 7: Run phicoind with the specified data directory
echo "Starting phicoind with --datadir=$DATA_DIR..."
./phicoind --datadir="$DATA_DIR" &
if [ $? -eq 0 ]; then
  echo "phicoind started successfully."
else
  echo "Error: Failed to start phicoind."
fi
