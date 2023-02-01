FROM ubuntu:focal
MAINTAINER James

RUN apt-get update && apt-get install --no-install-recommends xinetd bsdmainutils bc -qy && rm -rf /var/lib/apt/lists/*;
RUN useradd -m HouseofCats

CMD ["/usr/sbin/xinetd","-dontfork"]
