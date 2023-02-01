FROM ubuntu:18.04

# init
RUN apt-get update && apt-get install --no-install-recommends -y \
    software-properties-common && rm -rf /var/lib/apt/lists/*;

# c0ban
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  libtool \
  autotools-dev \
  automake \
  pkg-config \
  bsdmainutils \
  python3 \
  libevent-dev \
  libboost-system-dev \
  libboost-filesystem-dev \
  libboost-test-dev \
  libboost-thread-dev \
  libdb4.8-dev \
  libdb4.8++-dev \
  libprotobuf-dev \
  protobuf-compiler \
  libzmq3-dev \
  libminiupnpc-dev \
  libqrencode-dev \
  git && rm -rf /var/lib/apt/lists/*;

# for qt
RUN apt-get install --no-install-recommends -y \
  libqt5gui5 \
  libqt5core5a \
  libqt5dbus5 \
  qttools5-dev \
  qttools5-dev-tools && rm -rf /var/lib/apt/lists/*;

COPY . /c0ban
WORKDIR /c0ban

RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CXXFLAGS="--param ggc-min-expand=1 --param ggc-min-heapsize=32768"
RUN make -j4 install

# For test
# RUN pip3 install lyra2re2_hash