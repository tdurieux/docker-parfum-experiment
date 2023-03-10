FROM ubuntu:14.04

RUN sed -i s@/archive.ubuntu.com/@/mirrors.tencentyun.com/@g /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y apache2 zip vim unzip wget curl openssh-server && rm -rf /var/lib/apt/lists/*;
RUN { \
        echo mysql-community-server mysql-community-server/data-dir select ''; \
        echo mysql-community-server mysql-community-server/root-pass password 'root'; \
        echo mysql-community-server mysql-community-server/re-root-pass password 'root'; \
        echo mysql-community-server mysql-community-server/remove-test-db select false; \
    } | debconf-set-selections \
    && apt-get update && apt-get install --no-install-recommends -y mysql-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y apache2-dev php5 libapache2-mod-php5 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y php5-mysql php5-curl php5-gd php5-idn php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y python-pip && pip install --no-cache-dir --upgrade pip && python -m pip install pip==9.0.3 && pip2 install --no-cache-dir setuptools && apt-get install -y --no-install-recommends libmysqlclient-dev && apt install --no-install-recommends -y gcc && apt install --no-install-recommends -y python-dev && pip2 install --no-cache-dir netifaces requests && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libxss1 libappindicator1 libindicator7 \
    && rm -rf /var/lib/apt/lists/*
RUN cd /tmp && wget --no-check-certificate https://dominia.org/djao/limit/mod_limitipconn-0.24.tar.bz2 && tar jxvf mod_limitipconn-0.24.tar.bz2 && cd mod_limitipconn-0.24 && /usr/bin/apxs -c -i mod_limitipconn.c && rm -rf /tmp/* && rm mod_limitipconn-0.24.tar.bz2

COPY ./apache2.conf/ /etc/apache2/apache2.conf
RUN useradd -m web
COPY ./conf /conf
RUN chmod -R 700 /conf && rm -rf /var/www/html
COPY ./html /var/www/html
WORKDIR /var/www/html

EXPOSE 80
EXPOSE 22

CMD ['/conf/service.sh']