FROM ubuntu:focal
MAINTAINER James

RUN apt-get update && apt-get install --no-install-recommends xinetd -qy && rm -rf /var/lib/apt/lists/*;
RUN useradd -m Childnote
RUN chown -R root:root /home/Childnote
RUN chmod -R 755 /home/Childnote

CMD ["/usr/sbin/xinetd","-dontfork"]
