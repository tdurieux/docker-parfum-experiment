FROM debian:jessie

ARG packagename

RUN apt-get update && apt-get install --no-install-recommends -y $packagename && echo "\ndaemon off;" >> /etc/nginx/nginx.conf && rm -rf /var/lib/apt/lists/*;

CMD ["nginx"]

EXPOSE 80
