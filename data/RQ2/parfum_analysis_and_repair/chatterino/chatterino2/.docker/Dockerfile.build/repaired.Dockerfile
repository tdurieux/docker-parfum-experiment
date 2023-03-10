FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
        apt-get -y --no-install-recommends install wget libdbus-1-dev qt5-default && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install libboost-dev libssl-dev libboost-system-dev libboost-filesystem-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libpulse-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /build

RUN wget --quiet https://download.qt.io/official_releases/qt/5.12/5.12.4/qt-opensource-linux-x64-5.12.4.run && chmod +x *qt*.run
ADD qt-installer-noninteractive.qs .
RUN ls -la
RUN ./qt-opensource-linux-x64-*.run --platform minimal --verbose --script qt-installer-noninteractive.qs
RUN qtchooser -install 5.12.4 ~/Qt/5.12.4/gcc_64/bin/qmake
ENV QT_SELECT=5.12.4
RUN qmake --version

CMD ["/bin/sh"]
ENTRYPOINT ["./tools/docker/build.sh"]
