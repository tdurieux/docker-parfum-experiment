FROM ubuntu:focal
MAINTAINER James

RUN apt-get update && apt-get install --no-install-recommends xinetd -qy && rm -rf /var/lib/apt/lists/*;
RUN useradd -m Illusion
RUN chown -R root:root /home/Illusion
RUN chmod -R 755 /home/Illusion

CMD ["/usr/sbin/xinetd","-dontfork"]
