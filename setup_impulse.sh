#!/bin/bash
# 1. Setup Directory
mkdir -p ~/Impulse
cd ~/Impulse

# 2. Create the Restart Loop Script
cat <<EOF > run_app.sh
#!/bin/bash
while true; do
    timeout 15m python3 main.py
    sleep 2
done
EOF
chmod +x run_app.sh

# 3. Create the Systemd Service
cat <<EOF | sudo tee /etc/systemd/system/impulse.service
[Unit]
Description=Impulse Service
After=network.target

[Service]
WorkingDirectory=$(pwd)
ExecStart=/bin/bash $(pwd)/run_app.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# 4. Start and Enable
sudo systemctl daemon-reload
sudo systemctl enable impulse.service
sudo systemctl start impulse.service

echo "Server is configured and Impulse is running."
