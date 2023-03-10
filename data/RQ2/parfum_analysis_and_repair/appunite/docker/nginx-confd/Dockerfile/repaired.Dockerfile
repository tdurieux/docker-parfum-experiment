FROM nginx

MAINTAINER Jacek Marchwicki "jacek.marchwicki@gmail.com"

RUN apt-get update && apt-get install --no-install-recommends -y --force-yes wget apache2-utils && apt-get clean && rm -rf /var/lib/apt/lists/*;
# Install confd
RUN wget --no-check-certificate --output-document=/usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.7.1/confd-0.7.1-linux-amd64 && chmod +x /usr/local/bin/confd

# Prepare config files
RUN mkdir -p /etc/confd/{conf.d,templates}
COPY conf.d /etc/confd/conf.d
COPY templates /etc/confd/templates

# startup scripts
COPY scripts/ /usr/local/bin

# Setup nginx
RUN rm /etc/nginx/conf.d/*
RUN mkdir /etc/nginx/keys
COPY nginx /etc/nginx


EXPOSE 80
EXPOSE 443

CMD ["/usr/local/bin/boot.sh"]
