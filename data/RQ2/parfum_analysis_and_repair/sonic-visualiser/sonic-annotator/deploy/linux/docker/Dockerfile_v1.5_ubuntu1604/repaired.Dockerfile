FROM ubuntu:16.04
MAINTAINER Chris Cannam <cannam@all-day-breakfast.com>
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libbz2-dev \
    libfftw3-dev \
    libfishsound1-dev \
    libid3tag0-dev \
    liblo-dev \
    liblrdf0-dev \
    libmad0-dev \
    liboggz2-dev \
    libpulse-dev \
    libsamplerate-dev \
    libsndfile-dev \
    libsord-dev \
    libxml2-utils \
    portaudio19-dev \
    qt5-default libqt5svg5-dev \
    raptor-utils \
    librubberband-dev \
    git \
    mercurial \
    curl wget \
    yajl-tools \
    autoconf automake libtool lintian && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8
RUN hg clone https://code.soundsoftware.ac.uk/hg/vamp-plugin-sdk
RUN hg clone https://code.soundsoftware.ac.uk/hg/vamp-test-plugin
WORKDIR vamp-plugin-sdk
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make -j3
RUN mkdir ~/vamp
RUN cp examples/vamp-example-plugins.so ~/vamp/
WORKDIR ../vamp-test-plugin
RUN make -f Makefile.linux
RUN cp vamp-test-plugin.so ~/vamp/
WORKDIR ..
RUN hg clone -rsonic-annotator-1.5 https://code.soundsoftware.ac.uk/hg/sonic-annotator
WORKDIR sonic-annotator
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make -j3
RUN deploy/linux/deploy-deb.sh 1.5 amd64
RUN tar cvf output.tar *.deb && cp output.tar ..
