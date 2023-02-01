FROM ubuntu:focal
MAINTAINER James

RUN apt-get update && apt-get install --no-install-recommends xinetd -qy && rm -rf /var/lib/apt/lists/*;
RUN useradd -m EDUshell
RUN chown -R root:root /home/EDUshell
RUN chmod -R 755 /home/EDUshell

CMD ["/usr/sbin/xinetd","-dontfork"]
