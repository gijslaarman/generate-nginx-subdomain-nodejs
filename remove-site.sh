#!/bin/bash

# variables
NGINX_AVAILABLE_SITES='/etc/nginx/sites-available'
NGINX_ENABLED_SITES='/etc/nginx/sites-enabled'
DOMAIN_NAME=$1

rm $NGINX_AVAILABLE_SITES/$DOMAIN_NAME
rm $NGINX_ENABLED_SITES/$DOMAIN_NAME

read -p "A restart to Nginx is required for the subdomain to be defined. Do you wish to restart nginx? (y/$
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
  /etc/init.d/nginx restart;
fi