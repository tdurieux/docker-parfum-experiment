FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install --no-install-recommends -y xinetd socat busybox && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libpixman-1-0 libglib2.0-0 && rm -rf /var/lib/apt/lists/*;

CMD ["/usr/sbin/xinetd", "-dontfork"]

