FROM debian:bullseye

LABEL maintainer="Daniel-Constantin Mierla <miconda@gmail.com>"
LABEL description="Siremis installed from git master branch on Debian 11 (Bullseye)"
LABEL version="1.0.0"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y apt-utils && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y autoconf make procps git \
	vim apache2 php php-mysql php-gd php-curl php-xml libapache2-mod-php php-pear && rm -rf /var/lib/apt/lists/*;

RUN a2enmod rewrite && \
	a2enmod php7.4 && \
	pear install XML_RPC2

WORKDIR /var/www
RUN git clone https://github.com/asipto/siremis

WORKDIR /var/www/siremis
RUN make prepare24 && \
	make chown

COPY files/000-default.conf.apache24 /etc/apache2/sites-available/000-default.conf
COPY files/siremisrun.sh /usr/local/bin/siremisrun.sh

ENTRYPOINT ["/usr/local/bin/siremisrun.sh"]

