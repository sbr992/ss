#!/bin/bash

# 1. Ensure the service is enabled to run on boot
cat <<EOF | sudo tee /etc/systemd/system/impulse2.service
[Unit]
Description=Impulse Boot Runner
After=network.target

[Service]
# Points exactly to your existing folder and script
WorkingDirectory=/root/Impulse
ExecStart=/bin/bash /root/Impulse/run_app.sh

# Restart logic: Wait 10 minutes (600s) after the script finishes before starting again
Restart=always
RestartSec=600
User=root

[Install]
WantedBy=multi-user.target
EOF

# 2. Tell the system to load the new service
sudo systemctl daemon-reload
sudo systemctl enable impulse2.service

# 3. Start it immediately
sudo systemctl restart impulse2.service

echo "Done. Your existing run_app.sh is now a system service that starts on boot."
