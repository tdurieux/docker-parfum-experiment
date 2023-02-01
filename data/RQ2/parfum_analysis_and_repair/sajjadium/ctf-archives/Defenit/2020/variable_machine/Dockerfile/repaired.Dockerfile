FROM ubuntu:16.04
MAINTAINER c2w2m2

RUN apt update && apt install --no-install-recommends -y xinetd && rm -rf /var/lib/apt/lists/*;
ENV TERM=linux

RUN useradd ctf

CMD ["/usr/sbin/xinetd","-dontfork"]

