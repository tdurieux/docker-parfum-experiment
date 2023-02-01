FROM nginx:stable

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d

RUN apt-get update && apt-get install --no-install-recommends -y -q certbot python-certbot-nginx && rm -rf /var/lib/apt/lists/*;
