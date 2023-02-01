FROM debian:jessie
MAINTAINER L. Mangani <lorenzo@qxip.net>

RUN apt-get update && apt-get install --no-install-recommends -y nginx-full wget && rm -rf /var/lib/apt/lists/*; ENV DEBIAN_FRONTEND noninteractive


RUN wget https://github.com/QXIP/Qbana/archive/master.tar.gz -O /tmp/qbana.tar.gz && \
    tar zxf /tmp/qbana.tar.gz && mv Qbana-master/src/* /usr/share/nginx/html && rm /tmp/qbana.tar.gz
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
EXPOSE 80
