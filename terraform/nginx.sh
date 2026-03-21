#!/bin/bash

# Log everything for debugging
exec > /var/log/nginx-install.log 2>&1

echo "Starting NGINX installation..."

# Update system
apt-get update -y

# Install nginx
apt-get install -y nginx

# Enable nginx to start on boot
systemctl enable nginx

# Start nginx
systemctl start nginx

# Create a simple custom webpage
cat <<EOF > /var/www/html/index.html
<html>
<head>
  <title>Welcome</title>
</head>
<body>
  <h1>NGINX Installed Successfully </h1>
  <p>This VM is configured using Terraform + cloud-init</p>
</body>
</html>
EOF

# Restart nginx to load new page
systemctl restart nginx

echo "NGINX installation completed"
