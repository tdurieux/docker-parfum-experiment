FROM ubuntu:14.04
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
    raptor-utils \
    librubberband-dev \
    yajl-tools \
    git \
    mercurial \
    curl wget \
    mlton \
    autoconf automake libtool lintian && rm -rf /var/lib/apt/lists/*;

RUN apt-add-repository -y ppa:beineri/opt-qt-5.10.1-trusty
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    qt510base \
    qt510svg && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8

RUN hg clone -r[[REVISION]] https://code.soundsoftware.ac.uk/hg/sonic-annotator
RUN hg clone https://code.soundsoftware.ac.uk/hg/vamp-plugin-sdk
RUN hg clone https://code.soundsoftware.ac.uk/hg/vamp-test-plugin

WORKDIR /vamp-plugin-sdk
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-programs
RUN make plugins

WORKDIR /vamp-test-plugin
RUN make -f Makefile.linux

ENV VAMP_PATH /vamp-plugin-sdk/examples:/vamp-test-plugin

RUN git config --global http.postBuffer 4M

WORKDIR /root

COPY id_rsa_build .ssh/id_rsa_build
COPY known_hosts .ssh/known_hosts
RUN chmod 600 .ssh/id_rsa_build .ssh/known_hosts
RUN echo '{"accounts": {"sourcehut": "~breakfastquay"}}' > .repoint.json
RUN ( echo '[ui]' ; echo 'ssh = ssh -i /root/.ssh/id_rsa_build' ) > .hgrc

WORKDIR /sonic-annotator
ENV QTDIR /opt/qt510
ENV PATH /opt/qt510/bin:$PATH
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make -j3

RUN deploy/linux/deploy-appimage.sh
RUN tar cvf output-appimage.tar sonic-annotator *.AppImage && cp output-appimage.tar ..
