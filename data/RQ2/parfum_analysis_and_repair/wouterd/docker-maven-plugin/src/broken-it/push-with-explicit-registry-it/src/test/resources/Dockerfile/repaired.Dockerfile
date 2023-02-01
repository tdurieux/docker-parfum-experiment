FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y nginx && echo "\ndaemon off;" >> /etc/nginx/nginx.conf && rm -rf /var/lib/apt/lists/*;

CMD ["nginx"]

EXPOSE 80