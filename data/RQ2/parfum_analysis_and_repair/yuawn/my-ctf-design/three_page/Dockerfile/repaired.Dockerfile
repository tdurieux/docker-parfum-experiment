FROM ubuntu
MAINTAINER yuawn
RUN apt-get update
RUN apt-get install --no-install-recommends xinetd -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libc6-dev-i386 -y && rm -rf /var/lib/apt/lists/*;
RUN useradd -m three_page
RUN chown -R root:root /home/three_page
CMD ["/usr/sbin/xinetd","-dontfork"]