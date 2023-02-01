FROM ubuntu:16.04
MAINTAINER angelboy
RUN apt-get update
RUN apt-get install --no-install-recommends xinetd -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libc6-dev-i386 -y && rm -rf /var/lib/apt/lists/*;
RUN useradd -m critical_heap++
RUN chmod 774 /tmp
RUN chmod -R 774 /var/tmp
RUN chmod -R 774 /dev
RUN chmod -R 774 /run
RUN chmod 1733 /tmp /var/tmp /dev/shm
RUN chown -R root:root /home/critical_heap++
CMD ["/usr/sbin/xinetd","-dontfork"]
