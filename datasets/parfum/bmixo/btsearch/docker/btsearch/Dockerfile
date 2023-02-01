FROM debian:stable

RUN apt update
RUN apt install curl inetutils-ping net-tools dnsutils wget -y

WORKDIR /dist
COPY ./torrent-web ./torrent-web
ADD ./misc ./misc
RUN chmod +x /dist/torrent-web



CMD ["/dist/torrent-web"]
