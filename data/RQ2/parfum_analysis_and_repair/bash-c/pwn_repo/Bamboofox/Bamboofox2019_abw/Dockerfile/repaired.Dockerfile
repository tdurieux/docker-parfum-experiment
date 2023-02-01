FROM ubuntu:18.04
MAINTAINER Billy
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends xinetd -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3 -y && rm -rf /var/lib/apt/lists/*;
RUN useradd -m abw
COPY ./share /home/abw
COPY ./xinetd /etc/xinetd.d/abw
COPY ./flag /home/abw/flag
RUN chmod 774 /tmp
RUN chmod -R 774 /var/tmp
RUN chmod -R 774 /dev
RUN chmod -R 774 /run
RUN chmod 1733 /tmp /var/tmp /dev/shm
RUN chown -R root:root /home/abw
CMD ["/usr/sbin/xinetd","-dontfork"]
