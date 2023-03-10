FROM debian:buster-slim
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates debhelper build-essential fakeroot git zip python3-minimal \
      libpulse-dev libclalsadrv-dev \
      libboost-filesystem-dev libboost-locale-dev libboost-program-options-dev libboost-system-dev libicu-dev \
      qtbase5-dev && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -s /bin/bash -U -G users -d /build build

# TODO: link own static boost
USER build
RUN mkdir /build/zxtune && cd /build/zxtune && \
    git init && \
    git remote add --tags origin https://bitbucket.org/zxtune/zxtune.git && \
    echo "platform=linux\narch=x86_64\npackaging?=deb\ndistro?=buster" > variables.mak && \
    echo "qt.includes=/usr/include/x86_64-linux-gnu/qt5\nqt.bin=/usr/lib/x86_64-linux-gnu/qt5/bin/" >> variables.mak && \
    echo "cxx_flags=-fPIC\nboost.force_static=1\nlibraries.static=icuuc icudata\ntools.python=python3" >> variables.mak

WORKDIR /build/zxtune
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["package", "-C", "apps/bundle"]