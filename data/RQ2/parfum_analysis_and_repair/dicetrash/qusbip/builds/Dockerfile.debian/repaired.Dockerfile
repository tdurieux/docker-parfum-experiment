FROM debian:sid

RUN apt-get update && apt-get install --no-install-recommends -y \
 build-essential \
 libqt5webenginewidgets5 \
 pkg-config \
 libudev-dev \
 qt5-default \
 qtdeclarative5-dev \
 libwrap0-dev \
 npm && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt
COPY web/package.json web/package-lock.json web/
RUN npm --prefix web ci

COPY . .

RUN cp builds/debian_config.h config.h
RUN npm run --prefix web build
RUN qmake
RUN make
RUN mkdir -p pkgdir/usr/bin
RUN mkdir -p pkgdir/usr/share/polkit-1/actions
RUN mkdir -p pkgdir/usr/share/applications
RUN cp -r builds/DEBIAN pkgdir/
RUN cp LICENSE pkgdir/DEBIAN
RUN cp qusbip pkgdir/usr/bin/
RUN cp builds/org.qusbip.qusbip.policy pkgdir/usr/share/polkit-1/actions/
RUN cp builds/qusbip.desktop pkgdir/usr/share/applications/
RUN dpkg-deb -b pkgdir
RUN mv pkgdir.deb qusbip.deb
