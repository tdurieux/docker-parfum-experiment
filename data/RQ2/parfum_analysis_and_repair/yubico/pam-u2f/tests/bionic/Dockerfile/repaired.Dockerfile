FROM ubuntu:bionic
COPY . /pam-u2f
WORKDIR /pam-u2f
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update
RUN apt-get -qq upgrade
RUN apt-get install -y --no-install-recommends -qq software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:yubico/stable
RUN apt-get -qq update
RUN apt-get install -y --no-install-recommends -qq libudev-dev libssl-dev libfido2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends -qq build-essential autoconf automake libtool pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends -qq libpam-dev pamtester && rm -rf /var/lib/apt/lists/*;
RUN autoreconf -i .
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-man
RUN make clean all install
