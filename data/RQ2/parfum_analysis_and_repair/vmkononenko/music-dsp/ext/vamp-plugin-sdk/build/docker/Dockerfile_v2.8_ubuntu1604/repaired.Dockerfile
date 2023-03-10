FROM ubuntu:16.04
MAINTAINER Chris Cannam <cannam@all-day-breakfast.com>
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    locales \
    build-essential \
    libsndfile-dev \
    git \
    mercurial && rm -rf /var/lib/apt/lists/*;
RUN gcc --version
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8
RUN hg clone -rdf32b473b9b6 https://code.soundsoftware.ac.uk/hg/vamp-plugin-sdk
RUN hg clone https://code.soundsoftware.ac.uk/hg/vamp-test-plugin
WORKDIR vamp-plugin-sdk
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make
WORKDIR ../vamp-test-plugin
RUN make -f Makefile.linux
WORKDIR ../vamp-plugin-sdk
RUN test/run-test-plugin-regression.sh
RUN mkdir vamp-plugin-sdk-2.8.0-binaries-amd64-linux
RUN cp libvamp-sdk.a libvamp-hostsdk.a examples/vamp-example-plugins.so host/vamp-simple-host rdf/generator/vamp-rdf-template-generator vamp-plugin-sdk-2.8.0-binaries-amd64-linux
RUN tar cvzf vamp-plugin-sdk-2.8.0-binaries-amd64-linux.tar.gz vamp-plugin-sdk-2.8.0-binaries-amd64-linux
RUN tar cvf output.tar *.tar.gz && cp output.tar .. && rm output.tar
