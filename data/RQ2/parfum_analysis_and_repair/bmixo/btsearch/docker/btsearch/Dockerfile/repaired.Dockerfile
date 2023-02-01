FROM debian:stable

RUN apt update && apt install --no-install-recommends curl inetutils-ping net-tools dnsutils wget -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /dist
COPY ./torrent-web ./torrent-web
ADD ./misc ./misc
RUN chmod +x /dist/torrent-web



CMD ["/dist/torrent-web"]
