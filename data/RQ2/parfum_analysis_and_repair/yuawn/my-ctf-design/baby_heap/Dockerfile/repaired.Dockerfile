FROM ubuntu
MAINTAINER yuawn
RUN apt-get update
RUN apt-get install --no-install-recommends xinetd -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libc6-dev-i386 -y && rm -rf /var/lib/apt/lists/*;
RUN useradd -m baby_heap
RUN chown -R root:root /home/baby_heap
CMD ["/usr/sbin/xinetd","-dontfork"]