FROM ubuntu:bionic
MAINTAINER hans.zandbelt@zmartzone.eu

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y pkg-config make gcc gdb lcov valgrind vim curl iputils-ping wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y autoconf automake libtool && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev libjansson-dev libcurl4-openssl-dev check && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y apache2 apache2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libpcre2-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libapache2-mod-php libhiredis-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libcjose-dev && rm -rf /var/lib/apt/lists/*;

RUN a2enmod ssl
RUN a2ensite default-ssl

RUN echo "/usr/sbin/apache2ctl start && tail -f /var/log/apache2/error.log " >> /root/run.sh
RUN chmod a+x /root/run.sh

COPY . /root/mod_auth_openidc
WORKDIR /root/mod_auth_openidc

RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CFLAGS="-g -O0" LDFLAGS="-lrt"
#-I/usr/include/apache2
RUN make clean && make check
RUN make install

WORKDIR /root

ADD openidc.conf /etc/apache2/conf-available
RUN a2enconf openidc
RUN /usr/sbin/apache2ctl start

RUN mkdir -p /var/www/html/protected
RUN echo "<html><body><h1>Hello, <?php echo($_SERVER['REMOTE_USER']) ?></h1><pre><?php print_r(array_map(\"htmlentities\", apache_request_headers())); ?></pre><a href=\"/protected/?logout=https%3A%2F%2Flocalhost.zmartzone.eu%2Floggedout.html\">Logout</a></body></html>" >  /var/www/html/protected/index.php
RUN mkdir -p /var/www/html/api && cp /var/www/html/protected/index.php /var/www/html/api

# docker run -p 443:443 -it mod_auth_openidc /bin/bash -c "source /etc/apache2/envvars && valgrind --leak-check=full /usr/sbin/apache2 -X"
