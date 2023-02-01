# production system for ubertesting

FROM ubuntu:bionic
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends -q \
    build-essential \
    libmysqlclient-dev \
    libexpat-dev \
    libpq-dev \
    unixodbc-dev \
	libssl-dev \
	libboost-system-dev \
	libboost-program-options-dev \
	libicu-dev \
    flex \
    bison \
    git \
    php \
    php-mysql \
    php-curl \
    php-xml \
    php-dompdf \
    python \
    ssh \
    mysql-server \
    wget \
    xsltproc \
    && rm -rf /var/lib/apt/lists/* \
    && wget --no-check-certificate -q -O /odbc.tar.gz https://dev.mysql.com/get/Downloads/Connector-ODBC/5.3/mysql-connector-odbc-5.3.9-linux-ubuntu16.04-x86-64bit.tar.gz \
    && tar -zxf /odbc.tar.gz \
    && rm /odbc.tar.gz \    
    && mkdir -p /var/run/mysqld && chmod a+rwX /var/run/mysqld \
    && { mysqld & } && sleep 3 \
    && mysql -e 'CREATE DATABASE test; CREATE USER test@localhost; GRANT ALL PRIVILEGES ON test.* TO test@localhost;' \
    && mysqladmin shutdown

# add cmake as separate layer. Version 3.13.4 is MANDATORY, since need 'cp' for cdash and doesnt work with later!
RUN  wget --no-check-certificate -q -O /cmake.tar.gz https://cmake.org/files/v3.13/cmake-3.13.4-Linux-x86_64.tar.gz \
    && tar -zxf /cmake.tar.gz \
    && rm /cmake.tar.gz
ENV PATH $PATH:/cmake-3.13.4-Linux-x86_64/bin

ADD sphinx /root/.sphinx
ADD entry_point.sh /
VOLUME [ "/work", "/rlp" ]
WORKDIR /work
ENTRYPOINT ["bash", "/entry_point.sh"]
CMD []
