FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y openssl && rm -rf /var/lib/apt/lists/*

ADD pidalio-linux-amd64 /usr/bin/pidalio

RUN chmod +x /usr/bin/pidalio

CMD ["/usr/bin/pidalio"]
