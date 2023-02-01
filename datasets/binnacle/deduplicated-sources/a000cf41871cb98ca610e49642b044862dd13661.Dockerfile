FROM ubuntu:14.04

MAINTAINER NGINX Docker Maintainers "docker-maint@nginx.com"

ENV USE_NGINX_PLUS=false

# Set the debconf front end to Noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && apt-get install -y -q \
	apt-transport-https \
	jq \
	vim \
	curl \
	libffi-dev \
	libssl-dev \
	python \
	python-dev \
	python-pip \
	unzip \
	dnsutils \
	wget

COPY etc /etc
COPY usr /usr

RUN mkdir -p /etc/ssl/nginx && \
    cd /etc/ssl/nginx && \
	openssl req -nodes -newkey rsa:2048 -keyout key.pem -out csr.pem -subj "/C=US/ST=California/L=San Francisco/O=NGINX/OU=Professional Services/CN=web" && \
	openssl x509 -req -days 365 -in csr.pem -signkey key.pem -out certificate.pem && \
    /usr/local/sbin/install-nginx.sh && \
# forward request logs to Docker log collector
    mkdir -p /var/log/nginx && \
    chmod a+w /var/log/nginx && \
    mkdir -p /var/cache/nginx && \
    chmod a+w /var/cache/nginx && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stdout /var/log/nginx/error.log

CMD ["/usr/local/sbin/start.sh"]

EXPOSE 80 443
