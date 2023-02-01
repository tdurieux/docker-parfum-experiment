FROM debian:stable

RUN apt update && apt install --no-install-recommends curl inetutils-ping net-tools dnsutils wget -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /dist
COPY ./worker ./worker
RUN chmod +x /dist/worker



CMD ["/dist/worker"]
