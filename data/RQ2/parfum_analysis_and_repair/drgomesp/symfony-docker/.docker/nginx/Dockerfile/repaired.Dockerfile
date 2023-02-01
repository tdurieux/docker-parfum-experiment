FROM nginx

RUN apt-get update && \
    apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

COPY conf/nginx.conf /etc/nginx/nginx.conf
ADD sites-enabled/ /etc/nginx/sites-enabled/

CMD ["nginx", "-g", "daemon off;"]
