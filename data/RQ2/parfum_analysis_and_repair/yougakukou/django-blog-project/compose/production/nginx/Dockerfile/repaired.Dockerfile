FROM nginx:1.17.1

RUN apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated certbot python-certbot-nginx && rm -rf /var/lib/apt/lists/*;

RUN rm /etc/nginx/conf.d/default.conf

COPY ./compose/production/nginx/conf.d/*.conf /etc/nginx/conf.d/
# Proxy configurations
COPY ./compose/production/nginx/includes/ /etc/nginx/includes/


