FROM ubuntu:12.04

RUN apt-get update && apt-get install --no-install-recommends -y nginx zip curl && rm -rf /var/lib/apt/lists/*;

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN curl -f -o /usr/share/nginx/www/master.zip -L https://codeload.github.com/gabrielecirulli/2048/zip/master
RUN cd /usr/share/nginx/www/ && unzip master.zip && mv 2048-master/* . && rm -rf 2048-master master.zip

EXPOSE 80

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf"]

