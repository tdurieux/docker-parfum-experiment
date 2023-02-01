FROM ubuntu:focal
MAINTAINER James

RUN apt-get update && apt-get install --no-install-recommends xinetd -qy && rm -rf /var/lib/apt/lists/*;
RUN useradd -m tcachelab
RUN chown -R root:root /home/tcachelab
RUN chmod -R 755 /home/tcachelab

CMD ["/usr/sbin/xinetd","-dontfork"]
