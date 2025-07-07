#!/bin/bash
source vars.sh

# Enable IPv4 forwarding
run_frontend "sudo bash -c \"echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/01-ipv4-forward.conf\""

# Apply the changes
run_frontend "sudo sysctl --system"

# Install dependencies
run_frontend "sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3-netaddr nginx iptables-persistent"

# Install ansible
run_frontend "curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py; sudo python3 get-pip.py; rm -rf get-pip.py; sudo python3 -m pip install ansible"

# NAT configuration
run_frontend "sudo iptables -t nat -F; sudo iptables -t nat -A POSTROUTING -s $FRONTEND_CIDR_LAN -o eth1 -j MASQUERADE; sudo iptables-save > /etc/iptables/rules.v4"

# Configure certbot
run_frontend "sudo snap install --classic certbot; sudo ln -s /snap/bin/certbot /usr/bin/certbot; sudo certbot certonly --nginx --non-interactive --agree-tos --no-eff-email --no-redirect --email '$FRONTEND_DOMAIN_MAIL' --domain $FRONTEND_DOMAIN_NAME --cert-name '$FRONTEND_DOMAIN_NAME' --keep-until-expiring; sudo certbot renew --dry-run"
