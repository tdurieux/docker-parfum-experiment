FROM debian:stable

RUN apt update
RUN apt install curl inetutils-ping net-tools dnsutils wget -y

WORKDIR /dist
COPY ./server ./server
ADD ./config  ./config
RUN chmod +x /dist/server

CMD ["/dist/server"]
