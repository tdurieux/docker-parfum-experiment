FROM ubuntu:focal
MAINTAINER James

RUN apt-get update && apt-get install --no-install-recommends xinetd -qy && rm -rf /var/lib/apt/lists/*;
RUN useradd -m STACK
RUN chown -R root:root /home/STACK
RUN chmod -R 755 /home/STACK

CMD ["/usr/sbin/xinetd","-dontfork"]
