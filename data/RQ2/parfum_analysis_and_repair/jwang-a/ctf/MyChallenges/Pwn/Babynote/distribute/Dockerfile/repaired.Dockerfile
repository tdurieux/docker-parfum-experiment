FROM ubuntu:focal
MAINTAINER James

RUN apt-get update && apt-get install --no-install-recommends xinetd -qy && rm -rf /var/lib/apt/lists/*;
RUN useradd -m Babynote
RUN chown -R root:root /home/Babynote
RUN chmod -R 755 /home/Babynote

CMD ["/usr/sbin/xinetd","-dontfork"]
