FROM ubuntu:trusty
MAINTAINER Kamil Trzciński <ayufan@ayufan.eu>

RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

ADD / /app

EXPOSE 80
CMD ["nginx", "-c", "/app/nginx.conf"]
