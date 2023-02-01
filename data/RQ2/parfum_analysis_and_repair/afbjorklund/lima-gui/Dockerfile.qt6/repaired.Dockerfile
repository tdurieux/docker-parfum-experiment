# docker build -f Dockerfile.qt6 -t qt6-build .

FROM docker.io/ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y qt6-base-dev qtchooser qmake6 qt6-base-dev-tools g++ make && rm -rf /var/lib/apt/lists/*

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y pkg-config libgl-dev libqt6svg6-dev && rm -rf /var/lib/apt/lists/*

RUN ARCH=$(uname -m); printf "/usr/lib/qt6/bin\n/usr/lib/${ARCH}-linux-gnu\n" | tee /usr/lib/${ARCH}-linux-gnu/qtchooser/qt6-${ARCH}-linux-gnu.conf && for alias in 6 default qt6; do ln -s qt6-${ARCH}-linux-gnu.conf /usr/lib/${ARCH}-linux-gnu/qtchooser/$alias.conf; done && qtchooser -l # <https://bugs.launchpad.net/ubuntu/+source/qtchooser/+bug/1964763>

# docker run --rm -v $PWD:/build qt6-build

VOLUME /build

WORKDIR /build

CMD qmake && make
