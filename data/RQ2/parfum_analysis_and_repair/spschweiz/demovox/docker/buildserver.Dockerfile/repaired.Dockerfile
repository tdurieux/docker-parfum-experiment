FROM ubuntu:focal
WORKDIR /var/demovox

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Zurich
RUN ln -fs /usr/share/zoneinfo/Europe/Zurich /etc/localtime

RUN apt-get update \
    && apt-get install --no-install-recommends -y nodejs npm python ruby composer gettext php-xml && rm -rf /var/lib/apt/lists/*;
RUN npm install -g grunt-cli sass && npm cache clean --force;

# WP unit tests
RUN apt-get install --no-install-recommends -y php-mbstring php-mysql subversion mysql-client && rm -rf /var/lib/apt/lists/*;
#RUN apt-get install -y phpunit

# xdebug
RUN apt-get install --no-install-recommends -y php-dev php-pear && pecl install xdebug && rm -rf /var/lib/apt/lists/*;
RUN echo "export PHP_IDE_CONFIG=\"serverName=build\"" >> /root/.bashrc