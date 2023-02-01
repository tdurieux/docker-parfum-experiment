FROM ubuntu:18.04


RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get -y --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install php && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apache2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libapache2-mod-php gdb git && rm -rf /var/lib/apt/lists/*;

COPY ./test.so /usr/lib/php/20170718/test.so
COPY ./swoole.so /usr/lib/php/20170718/swoole.so
RUN chmod 755 /usr/lib/php/20170718/test.so
RUN chmod 755 /usr/lib/php/20170718/swoole.so
RUN rm /var/www/html/index.html
COPY index.php /var/www/html/index.php
COPY html.zip /var/www/html/html.zip
RUN chmod 755 -R /var/www/html/
COPY flag /flag
RUN chmod 755 /flag


RUN set -xe \
    && git clone https://github.com/longld/peda.git   ~/peda \
    && git clone https://github.com/scwuaptx/Pwngdb.git  ~/Pwngdb \ 
    && cp ~/Pwngdb/.gdbinit ~/



COPY ./php.ini /etc/php/7.2/apache2/php.ini
RUN chmod 755 /etc/php/7.2/apache2/php.ini
RUN echo "" > /etc/php/7.2/apache2/conf.d/20-json.ini



CMD service apache2 start & tail -F /var/log/apache2/access.log
