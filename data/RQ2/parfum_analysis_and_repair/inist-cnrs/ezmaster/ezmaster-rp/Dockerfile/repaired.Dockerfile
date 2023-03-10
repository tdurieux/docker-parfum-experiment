FROM nginx:1.21.3

# to help docker debugging
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y --no-install-recommends install vim curl && rm -rf /var/lib/apt/lists/*;

COPY ./entrypoint.sh /
COPY ./nginx.conf    /etc/nginx/nginx.conf
COPY ./index.html    /app/public/

# nginx config
RUN rm /etc/nginx/conf.d/default.conf
COPY ./ezmaster-instance-nginx.conf.tpl /etc/nginx/
COPY ./ezmaster-front-nginx.conf.tpl    /etc/nginx/
COPY ./ezmaster-webdav-nginx.conf.tpl   /etc/nginx/

RUN chmod go+rwX -R /var /run

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 35267
