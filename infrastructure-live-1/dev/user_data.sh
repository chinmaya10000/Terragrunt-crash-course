#!/bin/bash
set -ex
sudo yum update -y
sudo yum install -y nginx

# Create API page
mkdir -p /usr/share/nginx/html/api
echo "<h1>API Service - $(hostname -f)</h1>" > /usr/share/nginx/html/api/index.html

# Create APP page
mkdir -p /usr/share/nginx/html/app
echo "<h1>APP Service - $(hostname -f)</h1>" > /usr/share/nginx/html/app/index.html

sudo systemctl enable nginx
sudo systemctl start nginx
