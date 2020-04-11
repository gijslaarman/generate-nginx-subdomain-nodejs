#!/bin/bash

# Script to create new subdomains for your NodeJS applications.
# Inspired & copyed some bits from: https://github.com/karakanb/nginx-subdomain-generator-script

ok() { echo -e '\e[32m'$1'\e[m'; } # Green
die() { echo -e '\e[1;31m'$1'\e[m'; exit 1; }

# Variable definitions
DOMAIN=$1
PORT=$2
NGINX_AVAILABLE_SITES='/etc/nginx/sites-available'
NGINX_ENABLED_SITES='/etc/nginx/sites-enabled'
domainRegex='^([a-zA-Z0-9]([-a-zA-Z0-9]{0,61}[a-zA-Z0-9])?\.)?([a-zA-Z0-9]{1,2}([-a-zA-Z0-9]{0,252}[a-zA-Z0-9])?)\.([a-zA-Z]{2,63})$'
portRegex='^[0-9]+$'

# Error handling
[ $(id -g) != "0"] && die "Must run as root"
[ $# != "2" ] && die "Usage: $(basename $0) sub.domain.name portnumber"
if [[ ! $DOMAIN =~ $domainRegex ]]; then die "$DOMAIN is not a valid subdomainname."; fi
if [[ ! $PORT =~ $portRegex ]]; then die "$PORT is not a number"; fi

# Create the Nginx config file.
cat > $NGINX_AVAILABLE_SITES/$DOMAIN <<EOF
server {
        server_name $DOMAIN;

        location / {
                proxy_pass http://localhost:$PORT;
                proxy_http_version 1.1;
                proxy_set_header Upgrade \$http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host \$host;
                proxy_cache_bypass \$http_upgrade;
        }
}
EOF

ln -s $NGINX_AVAILABLE_SITES/$DOMAIN $NGINX_ENABLED_SITES/$DOMAIN

read -p "A restart to Nginx is required for the subdomain to be defined. Do you wish to restart nginx? (y/n): " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
  /etc/init.d/nginx restart;
fi

ok "Subdomain created for $DOMAIN."

read -p "Would you like to install a SSL certificate? (certbot) (y/n): " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
  certbot --nginx -d $DOMAIN;
fi

ok "Subdomain secured with SSL"