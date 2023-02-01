FROM aiogram/telegram-bot-api:latest

# Install dependencies
RUN apk add --no-cache nginx openssl \
 && mkdir /run/nginx/ \

 # enerate self-signed certificate
 && openssl \
    req -x509 -nodes -days 365000 -subj "/C=CA/ST=QC/O=Bot API/CN=bot-api" -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigne \
       -out /etc/ssl/certs/
    
 # Create nginx config
 && echo $'\n\
server { \n\
        listen 443 ssl http2 default_server; \n\
        listen [::]:443 ssl http2 default_server; \n\
        ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt; \n\
        ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key; \n\
        location / { \n\
            client_max_body_size 2000M; \n\
            proxy_pass http://127.0 \
               } \n\
'  /etc/nginx/conf.d/default.conf \
