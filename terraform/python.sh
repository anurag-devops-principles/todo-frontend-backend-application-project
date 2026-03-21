#!/bin/bash

# Redirect logs
exec > /var/log/python-bootstrap.log 2>&1

echo "Starting python setup"

# Install Python & pip
apt-get update -y
apt-get install -y python3 python3-pip curl gnupg2 unixodbc unixodbc-dev

# Install Microsoft ODBC Driver
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
> /etc/apt/sources.list.d/mssql-release.list

apt-get update -y
ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Install Python dependencies
pip3 install --upgrade pip
pip3 install -r requirements.txt

# Create Uvicorn systemd service
echo "Creating uvicorn service..."

cat <<EOF > /etc/systemd/system/uvicorn.service
[Unit]
Description=Uvicorn FastAPI Service
After=network.target

[Service]
User=root
WorkingDirectory=/opt/app
ExecStart=/usr/bin/python3 -m uvicorn app:app --host 0.0.0.0 --port 8000
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable & start service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable uvicorn
systemctl start uvicorn

echo "Python setup completed"
