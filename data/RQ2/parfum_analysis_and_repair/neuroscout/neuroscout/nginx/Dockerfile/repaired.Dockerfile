FROM nginx
RUN apt-get update && apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*;
RUN openssl dhparam -out /etc/nginx/dhparam.pem 2048
