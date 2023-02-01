FROM ubuntu:14.04
RUN apt-get -qq update
RUN apt-get -qq --no-install-recommends install -y gcc autoconf yasm pkg-config libtool make && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq --no-install-recommends install -y corosync libcorosync-dev crmsh && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq --no-install-recommends install -y liburcu-dev libqb-dev && rm -rf /var/lib/apt/lists/*;
ENV SHEEPSRC /usr/src/sheepdog
ENV SHEEPPORT 7000
ENV SHEEPSTORE /store
ADD ./docker/corosync.conf /etc/corosync/corosync.conf
ADD ./docker/run.sh /root/run.sh

WORKDIR $SHEEPSRC
ADD . $SHEEPSRC
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make check && make install

RUN mkdir $SHEEPSTORE

EXPOSE $SHEEPPORT
CMD /bin/bash /root/run.sh
