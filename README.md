# Automate the creation of NodeJS subdomains in NGINX > Ubuntu servers
Install this script to your server.
```bash
# Installation
wget -O subdomainGenerator.sh https://raw.githubusercontent.com/gijslaarman/generate-nginx-subdomain-nodejs/master/nodejs-subdomain.sh

# Run the script
sudo bash subdomainGenerator.sh subdomain.domain.com 1234 # 1234 = portnumber
```

Usage:
```bash
sudo bash nodejs-subdomain.sh [your.subdomain.com] [portNumber]
```

Outputs:
Nginx file for sites-available & sites-enabled.