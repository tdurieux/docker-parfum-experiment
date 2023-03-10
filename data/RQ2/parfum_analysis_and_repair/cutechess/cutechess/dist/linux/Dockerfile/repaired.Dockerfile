FROM ubuntu:bionic

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && add-apt-repository ppa:beineri/opt-qt-5.11.3-bionic && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y git qt511base qt511svg build-essential mesa-common-dev libglu1-mesa-dev && rm -rf /var/lib/apt/lists/*

ENV QT_BASE_DIR=/opt/qt511
ENV QTDIR=$QT_BASE_DIR
ENV PATH=$QT_BASE_DIR/bin:$PATH
ENV LD_LIBRARY_PATH=$QT_BASE_DIR/lib/x86_64-linux-gnu:$QT_BASE_DIR/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH=$QT_BASE_DIR/lib/pkgconfig:$PKG_CONFIG_PATH

# Install dependencies and build tools
RUN \
  apt-get update && apt-get install --no-install-recommends -y \
    ruby-dev \
    rpm \
    bsdmainutils \
    mandoc && \
  gem install fpm && rm -rf /var/lib/apt/lists/*;

# Download and build cutechess
RUN git clone https://github.com/cutechess/cutechess.git /cutechess
WORKDIR /cutechess
RUN qmake && \
  make -j4 && \
  make doc-txt && \
  make doc-html

# Create .deb and .rpm packages
RUN \
  mkdir -p /cutechess_pkg && \
  cd /cutechess_pkg && \
  mkdir -p usr/games && \
  mkdir -p usr/share/menu && \
  mkdir -p usr/share/pixmaps && \
  mkdir -p usr/share/applications && \
  mkdir -p usr/share/man/man6 && \
  mkdir -p usr/share/man/man5 && \
  mkdir -p usr/share/doc/cutechess && \
  cp /cutechess/projects/cli/cutechess-cli usr/games && \
  cp /cutechess/projects/gui/cutechess usr/games && \
  cp /cutechess/dist/linux/menu/cutechess usr/share/menu && \
  cp /cutechess/projects/gui/res/icons/cutechess_128x128.png usr/share/pixmaps/cutechess.png && \
  cp /cutechess/projects/gui/res/icons/cutechess_32x32.xpm usr/share/pixmaps/cutechess.xpm && \
  cp /cutechess/dist/linux/cutechess.desktop usr/share/applications && \
  cp /cutechess/docs/cutechess-cli.6 usr/share/man/man6 && \
  gzip usr/share/man/man6/cutechess-cli.6 && \
  cp /cutechess/docs/engines.json.5 usr/share/man/man5 && \
  gzip usr/share/man/man5/engines.json.5 && \
  cp /cutechess/COPYING usr/share/doc/cutechess/copyright && \
  cp /cutechess/README.md usr/share/doc/cutechess/README && \
  mkdir /finished_pkg && \
  export CUTECHESS_MAJOR_VERSION=$(awk -F= '/^CUTECHESS_MAJOR_VERSION/ { print $NF }' /cutechess/version.pri) && \
  export CUTECHESS_MINOR_VERSION=$(awk -F= '/^CUTECHESS_MINOR_VERSION/ { print $NF }' /cutechess/version.pri) && \
  export CUTECHESS_PATCH_VERSION=$(awk -F= '/^CUTECHESS_PATCH_VERSION/ { print $NF }' /cutechess/version.pri) && \
  export TODAY=$(date +%Y%m%d) && \
  fpm -s dir -t deb -C /cutechess_pkg \
    -a "amd64" \
    --license "GPLv3" \
    --url "https://github.com/cutechess/cutechess" \
    -n "cutechess" \
    -v "$TODAY+$CUTECHESS_MAJOR_VERSION.$CUTECHESS_MINOR_VERSION.$CUTECHESS_PATCH_VERSION" \
    --iteration 1 \
    --category "games" \
    -m "Ilari Pihlajisto <ilaripih@gmail.com>" \
    --description "Commandline and graphical interface for playing chess" \
    -d "libc6 (>= 2.27)" \
    -d "libgcc1 (>= 1:8.3.0)" \
    -d "libqt5svg5 (>= 5.11.0)" \
    -d "libqt5core5a (>= 5.11.0)" \
    -d "libqt5gui5 (>= 5.11.0)" \
    -d "libqt5widgets5 (>= 5.11.0)" \
    -d "libqt5printsupport5 (>= 5.11.0)" \
    -d "libqt5concurrent5 (>= 5.11.0)" \
    -d "libstdc++6 (>= 8.3.0)" && \
  mv /cutechess_pkg/*.deb /finished_pkg/ && \
  fpm -s dir -t rpm -C /cutechess_pkg \
    -a "x86_64" \
    --license "GPLv3" \
    --url "https://github.com/cutechess/cutechess" \
    -n "cutechess" \
    -v "$TODAY+$CUTECHESS_MAJOR_VERSION.$CUTECHESS_MINOR_VERSION.$CUTECHESS_PATCH_VERSION" \
    --iteration 1 \
    --category "Amusements/Games/Board/Chess" \
    -m "Ilari Pihlajisto <ilaripih@gmail.com>" \
    --description "Commandline and graphical interface for playing chess" \
    -d "qt5-qtbase >= 5.11.0" \
    -d "qt5-qtsvg >= 5.11.0" && \
  mv /cutechess_pkg/*.rpm /finished_pkg/

# Create .tar.gz package for cutechess-cli
RUN \
  cd /cutechess && \
  mkdir -p /cutechess_pkg/cutechess-cli && \
  cd /cutechess_pkg && \
  mkdir -p ./cutechess-cli/lib && \
  cp $QT_BASE_DIR/lib/libQt5Core.so.5 cutechess-cli/lib/ && \
  cp /cutechess/projects/cli/cutechess-cli cutechess-cli/ && \
  cp /cutechess/COPYING cutechess-cli/ && \
  cp /cutechess/docs/man-style.css cutechess-cli/ && \
  cp /cutechess/tools/clop-cutechess-cli.py cutechess-cli/ && \
  cp /cutechess/dist/linux/cutechess-cli.sh cutechess-cli/ && \
  cp /cutechess/docs/cutechess-cli.6.html cutechess-cli/ && \
  cp /cutechess/docs/cutechess-cli.6.txt cutechess-cli/ && \
  cp /cutechess/docs/engines.json.5.html cutechess-cli/ && \
  cp /cutechess/docs/engines.json.5.txt cutechess-cli/ && \
  tar -zcvf cutechess-cli-linux64.tar.gz cutechess-cli && \
  export CUTECHESS_MAJOR_VERSION=$(awk -F= '/^CUTECHESS_MAJOR_VERSION/ { print $NF }' /cutechess/version.pri) && \
  export CUTECHESS_MINOR_VERSION=$(awk -F= '/^CUTECHESS_MINOR_VERSION/ { print $NF }' /cutechess/version.pri) && \
  export CUTECHESS_PATCH_VERSION=$(awk -F= '/^CUTECHESS_PATCH_VERSION/ { print $NF }' /cutechess/version.pri) && \
  mv cutechess-cli-linux64.tar.gz /finished_pkg/cutechess-cli-$CUTECHESS_MAJOR_VERSION.$CUTECHESS_MINOR_VERSION.$CUTECHESS_PATCH_VERSION-linux64.tar.gz && rm cutechess-cli-linux64.tar.gz

# Copy the .deb package to the host
CMD cp /finished_pkg/cutechess*.* /package

