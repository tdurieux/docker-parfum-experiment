FROM ubuntu:focal
MAINTAINER James

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends xinetd -y && rm -rf /var/lib/apt/lists/*;
RUN useradd -m UnicornsAisle

CMD ["/usr/sbin/xinetd","-dontfork"]
