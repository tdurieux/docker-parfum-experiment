FROM ubuntu:18.04
LABEL maintainer="cL0und <cL0und@Syclover>"
RUN apt update && apt install --no-install-recommends -y nginx curl vim && rm -rf /var/lib/apt/lists/*;
COPY nginx.conf /etc/nginx/nginx.conf