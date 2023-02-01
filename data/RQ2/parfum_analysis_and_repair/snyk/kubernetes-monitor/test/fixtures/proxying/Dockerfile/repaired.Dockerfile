FROM debian:buster-slim

RUN apt-get update && apt-get install --no-install-recommends --yes tinyproxy && rm -rf /var/lib/apt/lists/*;

ADD tinyproxy.conf /etc/tinyproxy/tinyproxy.conf

CMD ["/usr/bin/tinyproxy", "-d"]
