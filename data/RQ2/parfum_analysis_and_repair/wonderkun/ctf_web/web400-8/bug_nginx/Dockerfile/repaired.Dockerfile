FROM ubuntu:16.04
MAINTAINER cl0und "cl0und@sycl0ver"
RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
ADD nginx/nginx.conf /etc/nginx/nginx.conf
RUN chmod 744 /etc/nginx/nginx.conf
ADD nginx/favicon.ico /home/