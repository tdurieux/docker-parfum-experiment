FROM therecipe/qt:rpi_base
LABEL maintainer therecipe


RUN QT=qtrpi-rpi1_qt-5.7.0.tar.gz && curl -f -sL --retry 10 --retry-delay 60 -O https://github.com/therecipe/files/releases/download/v0.0.0/$QT && tar -xzf $QT -C / && rm -f $QT

RUN git clone -q --depth 1 -b 5.7 https://github.com/qt/qtvirtualkeyboard.git /opt/qtrpi/raspi/qtvirtualkeyboard && cd /opt/qtrpi/raspi/qtvirtualkeyboard && ../qt5/bin/qmake qtvirtualkeyboard.pro CONFIG+=lang-all && make -j $(grep -c ^processor /proc/cpuinfo) && make install -j $(grep -c ^processor /proc/cpuinfo) && rm -rf /opt/qtrpi/raspi/qtvirtualkeyboard

RUN git clone -q --depth 1 -b 5.7 https://github.com/qt/qtmultimedia.git /opt/qtrpi/raspi/qtmultimedia && cd /opt/qtrpi/raspi/qtmultimedia && ../qt5/bin/qmake qtmultimedia.pro && make -j $(grep -c ^processor /proc/cpuinfo) && make install -j $(grep -c ^processor /proc/cpuinfo) && rm -rf /opt/qtrpi/raspi/qtmultimedia


RUN $GOPATH/bin/qtsetup prep
RUN $GOPATH/bin/qtsetup check rpi1
RUN $GOPATH/bin/qtsetup generate rpi1
RUN $GOPATH/bin/qtsetup install rpi1
RUN cd $GOPATH/src/github.com/therecipe/qt/internal/examples/widgets/line_edits && sed -i -e 's/AddWidget2/AddWidget/g' line_edits.go && $GOPATH/bin/qtdeploy build rpi1 && rm -rf ./deploy

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install ca-certificates git pkg-config && rm -rf /var/lib/apt/lists/*;