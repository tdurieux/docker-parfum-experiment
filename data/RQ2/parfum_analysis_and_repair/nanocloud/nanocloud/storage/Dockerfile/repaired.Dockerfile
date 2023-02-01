FROM debian:8.3
MAINTAINER Romain Soufflet <romain.soufflet@nanocloud.com>

RUN apt-get update && \
    apt-get -y --no-install-recommends install samba && rm -rf /var/lib/apt/lists/*;

COPY smb.conf /etc/samba/smb.conf

EXPOSE 445
EXPOSE 445/udp
EXPOSE 9090

RUN mkdir /opt/Users

CMD ["sh", "-c", "smbd -D; nmbd -D; /opt/plaza/plaza"]
