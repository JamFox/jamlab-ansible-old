#!/bin/bash
# Managed by jamlab-ansible

# Script to run after certbot renewal service

cat /etc/letsencrypt/live/jamfox.dev/cert.pem /etc/letsencrypt/live/jamfox.dev/privkey.pem > /etc/letsencrypt/live/jamfox.dev/haproxy.pem
systemctl restart haproxy
