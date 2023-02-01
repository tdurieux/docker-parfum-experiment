FROM ubuntu:18.04
MAINTAINER Chris Cannam <cannam@all-day-breakfast.com>
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    software-properties-common \
    build-essential \
    libbz2-dev \
    libfftw3-dev \
    libfishsound1-dev \
    libid3tag0-dev \
    liblo-dev \
    liblrdf0-dev \
    libmad0-dev \
    liboggz2-dev \
    libopus-dev \
    libopusfile-dev \
    libpulse-dev \
    libasound2-dev \
    libjack-dev \
    libsamplerate-dev \
    libsndfile-dev \
    libsord-dev \
    libxml2-utils \
    libgl1-mesa-dev \
    raptor2-utils \
    librubberband-dev \
    portaudio19-dev \
    qt5-default libqt5svg5-dev \
    git \
    mercurial \
    curl wget unzip \
    mlton \
    python3-pip \
    autoconf automake libtool lintian && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN git config --global http.postBuffer 4M

RUN git clone https://github.com/sandstorm-io/capnproto
WORKDIR capnproto
RUN git checkout v0.6.1
WORKDIR c++
RUN autoreconf -i && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared=no --enable-static=yes && make -j3 && make install

WORKDIR /root
RUN pip3 install --no-cache-dir meson

RUN wget https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-linux.zip
RUN unzip ninja-linux.zip
RUN ln -s $(pwd)/ninja /usr/bin/ninja

COPY id_rsa_build .ssh/id_rsa_build
COPY known_hosts .ssh/known_hosts
RUN chmod 600 .ssh/id_rsa_build .ssh/known_hosts
RUN echo '{"accounts": {"sourcehut": "~breakfastquay"}}' > .repoint.json
RUN ( echo '[ui]' ; echo 'ssh = ssh -i /root/.ssh/id_rsa_build' ) > .hgrc

RUN rm -f /usr/lib/x86_64-linux-gnu/librubberband.so*

# The explicit revision number here is to make sure the following git
# clone is not cached from a different revision
RUN echo Cloning revision [[REVISION]]

RUN git clone https://github.com/sonic-visualiser/sonic-visualiser
WORKDIR sonic-visualiser
RUN git checkout [[REVISION]]

RUN ./repoint install
RUN meson build --buildtype release
RUN ninja -C build

RUN deploy/linux/deploy-deb.sh [[RELEASE]] amd64
RUN tar cvf output-deb.tar *.deb && cp output-deb.tar /tmp/
