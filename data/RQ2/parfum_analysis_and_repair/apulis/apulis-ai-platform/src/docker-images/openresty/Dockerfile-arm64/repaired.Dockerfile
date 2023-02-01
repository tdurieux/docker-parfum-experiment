FROM apulistech/openresty:base

ADD config/nginx/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
ADD lib/resty /usr/local/openresty/nginx/jwt-lua/resty
ADD start.sh /
RUN apt update && apt install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN chmod +x /start.sh

