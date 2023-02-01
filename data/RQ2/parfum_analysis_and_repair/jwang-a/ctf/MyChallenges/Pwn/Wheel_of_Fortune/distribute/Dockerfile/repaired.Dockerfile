FROM ubuntu:focal
MAINTAINER James

RUN apt-get update && apt-get install --no-install-recommends xinetd -qy && rm -rf /var/lib/apt/lists/*;
RUN useradd -m WOF
RUN chown -R root:root /home/WOF
RUN chmod -R 755 /home/WOF

CMD ["/usr/sbin/xinetd","-dontfork"]
