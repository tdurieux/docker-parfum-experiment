FROM ubuntu:20.04
MAINTAINER <Orange Tsai> orange@chroot.org

EXPOSE 80/tcp

RUN apt update && apt install --no-install-recommends -y libcurl4-openssl-dev openssl libssl-dev python3 python3-pip nfs-common && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pycurl flask certifi

COPY app/                 /app
COPY files/readflag       /readflag
COPY files/flag           /flag
COPY files/entrypoint.sh  /

WORKDIR /app/
CMD ["/entrypoint.sh"]