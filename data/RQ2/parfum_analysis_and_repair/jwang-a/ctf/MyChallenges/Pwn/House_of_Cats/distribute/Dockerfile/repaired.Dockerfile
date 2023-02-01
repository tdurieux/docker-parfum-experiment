FROM ubuntu:focal
MAINTAINER James

RUN apt-get update && apt-get install --no-install-recommends xinetd bsdmainutils bc -qy && rm -rf /var/lib/apt/lists/*;
RUN useradd -m HouseofCats
RUN chown -R root:root /home/HouseofCats
RUN chmod -R 755 /home/HouseofCats

CMD ["/usr/sbin/xinetd","-dontfork"]
