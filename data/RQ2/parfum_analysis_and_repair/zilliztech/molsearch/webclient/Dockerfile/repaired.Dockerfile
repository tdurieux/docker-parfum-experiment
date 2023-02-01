#docker build -f Dockerfile.os.build -t molsearch:base .
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list

RUN apt-get update
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nginx php-fpm && rm -rf /var/lib/apt/lists/*;
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e "s/;\?daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.2/fpm/php-fpm.conf

RUN apt-get install --no-install-recommends -y dialog apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:inkscape.dev/stable
RUN apt update
RUN apt-get -y --no-install-recommends install inkscape && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install unzip && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install imagemagick && \
  apt-get -y --no-install-recommends install nodejs && \
  apt-get -y --no-install-recommends install npm && rm -rf /var/lib/apt/lists/*;

WORKDIR /var/www/html
COPY . /var/www/html

# Nginx config
RUN rm -rf /etc/nginx/sites-available && rm -rf /etc/nginx/sites-enabled/default
COPY default /etc/nginx/sites-enabled/default

RUN npm install -g bower && \
  npm install -g grunt-cli && \
  npm install grunt --save-dev && \
  npm install grunt-contrib-clean grunt-contrib-uglify grunt-text-replace grunt-contrib-less grunt-svgmin grunt-contrib-copy grunt-contrib-watch && npm cache clean --force;

# Make our shell script executable
RUN chmod +x env.sh

RUN ./env.sh
RUN echo '{ "allow_root": true }' > /root/.bowerrc
RUN chmod a+x build.sh
RUN ./build.sh fetch jmol

# CMD ["/bin/bash", "-c", "/var/www/html/env.sh && /etc/init.d/php7.2-fpm start && nginx -t"]
CMD ["/bin/bash", "-c", "/var/www/html/env.sh && /etc/init.d/php7.2-fpm start && /etc/init.d/nginx start"]

# Expose ports.
EXPOSE 80