FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

RUN usermod -u 1000 www-data
CMD ["nginx"]

EXPOSE 80
EXPOSE 443