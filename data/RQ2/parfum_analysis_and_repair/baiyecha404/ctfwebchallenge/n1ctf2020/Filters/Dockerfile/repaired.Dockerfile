FROM ubuntu:18.04

RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/mirrors.ustc.edu.cn/g" /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y --no-install-recommends install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apache2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install php && rm -rf /var/lib/apt/lists/*;

RUN rm /var/www/html/index.html
COPY index.php /var/www/html/
RUN chmod -R 755 /var/www/html/

COPY flag /tmp/flag
RUN cat /tmp/flag > /var/www/html/`cat /tmp/flag`
RUN rm -rf /tmp/flag

CMD service apache2 restart & tail -F /var/log/apache2/access.log;


