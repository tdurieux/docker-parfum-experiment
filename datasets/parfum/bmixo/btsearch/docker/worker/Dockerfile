FROM debian:stable

RUN apt update
RUN apt install curl inetutils-ping net-tools dnsutils wget -y

WORKDIR /dist
COPY ./worker ./worker
RUN chmod +x /dist/worker



CMD ["/dist/worker"]
