#!/bin/sh

set -e

# substitute env variables inside template and then put the output on nginx config files folder
envsubst '$APP_HOST' < /etc/nginx/nginx.template.conf > /etc/nginx/nginx.conf

# daemon off if for running in foreground to see logs with docker
nginx -g 'daemon off;'
