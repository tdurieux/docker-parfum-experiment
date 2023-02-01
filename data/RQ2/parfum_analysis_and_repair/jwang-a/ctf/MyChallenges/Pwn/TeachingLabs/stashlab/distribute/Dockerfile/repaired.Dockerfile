FROM ubuntu:focal
MAINTAINER James

RUN apt-get update && apt-get install --no-install-recommends xinetd -qy && rm -rf /var/lib/apt/lists/*;
RUN useradd -m stashlab
RUN chown -R root:root /home/stashlab
RUN chmod -R 755 /home/stashlab

CMD ["/usr/sbin/xinetd","-dontfork"]
