FROM ubuntu:16.04

RUN apt-get update -q && apt-get install --no-install-recommends -qy git bash curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get update -q && apt-get install --no-install-recommends -qy build-essential && rm -rf /var/lib/apt/lists/*;

ENV GCC_ARM_URL="https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q1-update/+download/gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2"
ENV GCC_ARM_VERSION="5_3-2016q1"

RUN dpkg --add-architecture i386 && apt-get update -q && apt-get install --no-install-recommends -qy make isomd5sum bzip2 vim-common libarchive-zip-perl libc6:i386 \
  && curl -f -o /tmp/gcc-arm-none-eabi.tar.bz2 -sSL ${GCC_ARM_URL} \
  && tar xjvf /tmp/gcc-arm-none-eabi.tar.bz2 -C /usr/local \
  && mv /usr/local/gcc-arm-none-eabi-${GCC_ARM_VERSION}/ /usr/local/gcc-arm-embedded \
  && apt-get remove -qy bzip2 && apt-get clean && apt-get purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/local/gcc-arm-embedded/share && rm /tmp/gcc-arm-none-eabi.tar.bz2

ENV PATH /usr/local/gcc-arm-embedded/bin:$PATH

COPY scripts /scripts

ENV BOOST_VERSION=1_65_0
ENV BOOST_HOME=/boost
ENV BOOST_ROOT=$BOOST_HOME/boost_$BOOST_VERSION

RUN bash /scripts/download_boost.sh
RUN bash /scripts/build_boost.sh

RUN apt-get update -q && apt-get install --no-install-recommends -qy dfu-util && rm -rf /var/lib/apt/lists/*;

WORKDIR /firmware/build
CMD bash
