FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y bc git build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y linux-headers-amd64 && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/luigirizzo/netmap.git /usr/src/netmap
RUN cd /usr/src/netmap/LINUX && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --kernel-dir=$(ls -d /usr/src/linux-headers-*-amd64)
RUN cd /usr/src/netmap/LINUX && make
RUN cd /usr/src/netmap/LINUX && make apps
RUN cd /usr/src/netmap/LINUX && make install

RUN modprobe netmap

CMD .src/netmap/LINUX/build-apps/pkt-gen/pkt-gen -i eth0 -f tx -l 60
#RUN apt-get -y install kernel-package
#RUN apt-get -y install linux-source

#RUN git clone https://github.com/luigirizzo/netmap.git
#WORKDIR netmap/LINUX

#RUN ./configure
#RUN make
#RUN make apps
#RUN make install