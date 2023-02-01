FROM ubuntu:bionic

RUN apt-get update \
  && apt-get install --no-install-recommends -y alsa alsa-utils wget gcc python3 python3-pip python3-dev mosquitto-clients \
  && pip3 install --no-cache-dir --upgrade pip \
  && rm -rf /var/lib/apt/lists/*
RUN wget https://sourceforge.net/projects/cmusphinx/files/sphinxbase/5prealpha/sphinxbase-5prealpha.tar.gz/download -O sphinxbase.tar.gz
RUN wget https://sourceforge.net/projects/cmusphinx/files/pocketsphinx/5prealpha/pocketsphinx-5prealpha.tar.gz/download -O pocketsphinx.tar.gz
RUN tar -xzvf sphinxbase.tar.gz && rm sphinxbase.tar.gz
RUN tar -xzvf pocketsphinx.tar.gz && rm pocketsphinx.tar.gz
RUN apt-get update && apt-get install --no-install-recommends -y bison libasound2-dev swig && rm -rf /var/lib/apt/lists/*;
WORKDIR /sphinxbase-5prealpha
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-fixed
RUN make
RUN make install
WORKDIR /pocketsphinx-5prealpha
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN  make install
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

WORKDIR /
COPY audio2text.sh /
CMD ./audio2text.sh
