FROM ubuntu:bionic

RUN apt-get update
RUN apt-get install --no-install-recommends apt-utils -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends bsdmainutils -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:bitcoin/bitcoin -y
RUN apt-get update

RUN apt-get install --no-install-recommends make -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gcc -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends g++ -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends pkg-config -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends autoconf -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libtool -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libboost-all-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libssl1.0-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libevent-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libdb4.8-dev libdb4.8++-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libzmq3-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3.8 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3-zmq -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir zmq

WORKDIR /app
COPY . .

WORKDIR /app/src/GMock
RUN autoreconf -fvi

WORKDIR /app
RUN make distclean || true
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-tests --without-gui
RUN make

RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu
RUN echo "ubuntu:ubuntu" | chpasswd && adduser ubuntu sudo
USER ubuntu

CMD ["bash"]
