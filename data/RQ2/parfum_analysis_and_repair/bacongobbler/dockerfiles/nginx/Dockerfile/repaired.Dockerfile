FROM        ubuntu
MAINTAINER  Matthew Fisher <me@bacongobbler.com>

# install nginx
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

ADD nginx.conf  /etc/nginx/nginx.conf
ADD default     /etc/nginx/sites-enabled/default

WORKDIR /etc/nginx

EXPOSE  80

CMD nginx
