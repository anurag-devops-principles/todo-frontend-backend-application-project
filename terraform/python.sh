#!/bin/bash

# Redirect logs
exec > /var/log/python-bootstrap.log 2>&1

echo "Starting Python & FastAPI setup"

# Update system
apt-get update -y

# Install base dependencies
apt-get install -y \
    python3 \
    python3-pip \
    curl \
    gnupg2 \
    unixodbc \
    unixodbc-dev \
    git

# Install Microsoft ODBC Driver
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" \
> /etc/apt/sources.list.d/mssql-release.list

apt-get update -y
ACCEPT_EULA=Y apt-get install -y msodbcsql18

# Upgrade pip
pip3 install --upgrade pip

# Install Python packages directly
pip3 install \
    pyodbc \
    fastapi \
    "uvicorn[standard]" \
    pydantic \
    azure-identity \
    python-dotenv

# Create app directory
mkdir -p /opt/app

# Create sample app (remove if you already copy your own app)
cat <<EOF > /opt/app/app.py
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def health():
    return {"status": "FastAPI running"}
EOF

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

# Enable & Start Service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable uvicorn
systemctl start uvicorn

echo "Python FastAPI setup completed"
