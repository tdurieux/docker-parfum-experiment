FROM phusion/baseimage:0.11

ENTRYPOINT ["/sbin/my_init", "--"]

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    nginx \
    rsync && rm -rf /var/lib/apt/lists/*;

# near-wallet
RUN mkdir /near-wallet
COPY ./build /var/www/html/wallet

# nginx
RUN rm /etc/nginx/sites-enabled/default
COPY /scripts/wallet.nginx /etc/nginx/sites-enabled/wallet
COPY /scripts/init_nginx.sh /etc/my_init.d/
