FROM ubuntu:focal

# xinetd
RUN apt-get update && apt-get -y upgrade
RUN apt-get install --no-install-recommends -y lib32z1 xinetd wget && rm -rf /var/lib/apt/lists/*;

ARG DEBIAN_FRONTEND=noninteractive

# Sage and dependencies
RUN apt-get install --no-install-recommends -y sagemath && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y hashcash && rm -rf /var/lib/apt/lists/*;

RUN useradd -u 8888 -m pwn

USER pwn

COPY ./share/* /home/pwn/

COPY ./xinetd /etc/xinetd.d/sage-service

CMD ["/usr/sbin/xinetd", "-dontfork"]
