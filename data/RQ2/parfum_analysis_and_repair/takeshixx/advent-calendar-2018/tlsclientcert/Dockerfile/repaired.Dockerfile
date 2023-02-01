FROM ubuntu:18.04
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/src/app
COPY nginx.conf /etc/nginx/nginx.conf
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

