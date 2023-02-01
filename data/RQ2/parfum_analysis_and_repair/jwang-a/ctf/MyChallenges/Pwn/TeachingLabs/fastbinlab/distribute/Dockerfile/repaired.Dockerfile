FROM ubuntu:focal
MAINTAINER James

RUN apt-get update && apt-get install --no-install-recommends xinetd -qy && rm -rf /var/lib/apt/lists/*;
RUN useradd -m fastbinlab
RUN chown -R root:root /home/fastbinlab
RUN chmod -R 755 /home/fastbinlab

CMD ["/usr/sbin/xinetd","-dontfork"]
