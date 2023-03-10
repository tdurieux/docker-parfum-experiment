FROM nginx:latest

COPY nginx.prod.conf /etc/nginx/nginx.conf
COPY ssl_params.conf /etc/nginx/ssl_params.conf

COPY ssl/dhparam.pem /etc/nginx/dhparam.pem
COPY ssl/nolik.im.crt /etc/nginx/nolik.im.crt
COPY ssl/nolik.im.key /etc/nginx/nolik.im.key