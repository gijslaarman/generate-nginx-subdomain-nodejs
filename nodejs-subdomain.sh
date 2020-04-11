#!/bin/bash

# Variable definitions
DOMAIN=$1
PORT=$2
NGINX_AVAILABLE_SITES='/etc/nginx/sites-available'
NGINX_ENABLED_SITES='/etc/nginx/sites-enabled'

# Create the Nginx config file.
cat > $NGINX_AVAILABLE_SITES/$DOMAIN <<EOF
server {
        server_name $DOMAIN;

        location / {
                proxy_pass http://localhost:$PORT;
                proxy_http_version 1.1;
                proxy_set_header Upgrade '$http_upgrade';
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host '$host';
                proxy_cache_bypass '$http_upgrade';
        }
}
EOF

ln -s $NGINX_AVAILABLE_SITES/$DOMAIN $NGINX_ENABLED_SITES/$DOMAIN

read -p "A restart to Nginx is required for the subdomain to be defined. Do you wish to restart nginx? (y/$
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
  /etc/init.d/nginx restart;
fi

"Subdomain created for $DOMAIN."



# server {
#         server_name subdomain.gijsbertcharles.com;

#         location / {
#                 proxy_pass http://localhost:3000;
#                 proxy_http_version 1.1;
#                 proxy_set_header Upgrade $http_upgrade;
#                 proxy_set_header Connection 'upgrade';
#                 proxy_set_header Host $host;
#                 proxy_cache_bypass $http_upgrade;
#         }
# }