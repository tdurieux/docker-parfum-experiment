# Dockerfile-nginx

FROM nginx:latest

# Nginx will listen on this port
EXPOSE 80

# Remove the default config file that
# /etc/nginx/nginx.conf includes