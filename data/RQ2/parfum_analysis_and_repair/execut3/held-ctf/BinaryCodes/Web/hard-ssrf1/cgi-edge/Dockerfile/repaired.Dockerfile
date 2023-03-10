# Docker file for python simple webservice build

FROM ubuntu:12.04
MAINTAINER Execut3 <execut3@binarycodes.ir>
RUN apt-get update

RUN apt-get install --no-install-recommends -y build-essential checkinstall && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/src && wget https://www.python.org/ftp/python/3.2.2/Python-3.2.2.tgz --no-check-certificate && \
    tar xvf Python-3.2.2.tgz && cd Python-3.2.2 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install && rm Python-3.2.2.tgz

RUN apt-get -y --no-install-recommends install apache2 && rm -rf /var/lib/apt/lists/*;

# Http settings
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

RUN mkdir -p /production/www/cgi-bin
RUN mkdir -p /production/www/lib
COPY cgi-bin /usr/lib/cgi-bin
#COPY lib /production/www/lib
COPY apache2 /etc/apache2
RUN ln -s /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load

COPY python-patch/client.py /usr/src/Python-3.2.2/Lib/http/client.py
COPY python-patch/idna.py /usr/local/lib/python3.2/encodings/idna.py

EXPOSE 80

RUN apt-get install --no-install-recommends python-pip -y && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "/usr/sbin/apache2" ]
CMD ["-D", "FOREGROUND"]

