# Special thanks to Tai Kersten who initially built this
# To run this image you need the following environment variables to be set
# ALLOWED_IPS: a bash list of ips that will be allowed to access the node

# Pull all binaries into a second stage deploy alpine container
FROM kunstmaan/ethereum-geth
RUN apt-get update

RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y apache2-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;

RUN htpasswd -c /etc/nginx/protected.htpasswd demo
COPY protected.htpasswd demo
COPY ./default /etc/nginx/sites-available/default
COPY ./config_nginx.py /config_nginx.py

RUN apt-get update
RUN apt-get install --no-install-recommends -qq -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qq -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:certbot/certbot
RUN apt-get -y --no-install-recommends install ufw && rm -rf /var/lib/apt/lists/*;
# RUN apt-get -y install python-certbot-nginx
# RUN certbot --nginx

EXPOSE 80 8545 8546 30303 30303/udp

ENTRYPOINT ["nginx", "-g", "daemon off;"]