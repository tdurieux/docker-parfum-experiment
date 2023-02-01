FROM debian:stable

RUN apt update && apt install --no-install-recommends curl inetutils-ping net-tools dnsutils wget -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /dist
COPY ./server ./server
ADD ./config  ./config
RUN chmod +x /dist/server

CMD ["/dist/server"]
