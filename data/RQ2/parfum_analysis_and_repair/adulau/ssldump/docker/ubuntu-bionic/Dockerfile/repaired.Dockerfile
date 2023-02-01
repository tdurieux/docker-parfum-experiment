FROM ubuntu:bionic

ENV LANG C
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends ca-certificates sudo git build-essential automake autoconf clang libssl-dev libpcap-dev libnet1-dev libjson-c-dev iproute2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN useradd -ms /bin/bash ssldump
RUN passwd -d ssldump
RUN printf 'ssldump ALL=(ALL) ALL\n' | tee -a /etc/sudoers

USER ssldump

RUN cd /home/ssldump && \
	git clone https://github.com/adulau/ssldump.git build

RUN cd /home/ssldump/build && \
	./autogen.sh && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CC=/usr/bin/clang && \
	make && \
	sudo make install

WORKDIR "/home/ssldump"

CMD ["/bin/bash"]
