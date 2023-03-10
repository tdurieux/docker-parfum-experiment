FROM nginx

COPY nginx-watch.sh /etc/nginx/

COPY conf/dblog /etc/nginx/conf.d

COPY maintenance /var/www/maintenance

RUN apt-get update && apt-get -y --no-install-recommends install inotify-tools screen && rm -rf /var/lib/apt/lists/*;

# Watch will restart nginx on every change in configuration files caused by ENGRAVE app
WORKDIR /etc/nginx
RUN chmod +x ./nginx-watch.sh

EXPOSE 80
EXPOSE 443

CMD screen -d -m -t watch sh ./nginx-watch.sh && exec nginx -g 'daemon off;'