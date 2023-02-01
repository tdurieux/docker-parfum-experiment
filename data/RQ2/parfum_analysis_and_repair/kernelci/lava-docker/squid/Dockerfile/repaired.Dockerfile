FROM debian:9

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y squid3 && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /sbin/entrypoint.sh
COPY squid.conf /etc/squid/squid.conf
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp
CMD "/sbin/entrypoint.sh"
