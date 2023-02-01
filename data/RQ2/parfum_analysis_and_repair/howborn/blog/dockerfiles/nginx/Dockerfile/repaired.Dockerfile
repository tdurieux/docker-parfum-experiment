FROM nginx:latest

RUN sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && apt-get update && apt-get install --no-install-recommends -y cron wget python && rm -rf /var/lib/apt/lists/*;

ADD nginx.conf /etc/nginx/nginx.conf

ADD *.sh /
RUN chmod 777 /*.sh

ADD ssl/* /var/www/ssl/
RUN chmod +x /var/www/ssl/*.sh
RUN chmod 777 -R /var/log/nginx