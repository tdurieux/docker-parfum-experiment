FROM therecipe/qt:rpi_base
LABEL maintainer therecipe

RUN QT=qtrpi-rpi2_qt-5.7.0.zip && curl -f -sL --retry 10 --retry-delay 60 -O http://www.qtrpi.com/downloads/qtrpi/rpi2/$QT && unzip -qq $QT -d /opt/qtrpi && rm -f $QT
RUN git clone -q --depth 1 -b 5.7 https://code.qt.io/qt/qtvirtualkeyboard.git /opt/qtrpi/raspi/qtvirtualkeyboard && cd /opt/qtrpi/raspi/qtvirtualkeyboard && ../qt5/bin/qmake qtvirtualkeyboard.pro CONFIG+=lang-all && make && make install && rm -rf /opt/qtrpi/raspi/qtvirtualkeyboard

RUN $GOPATH/bin/qtsetup check rpi2
RUN $GOPATH/bin/qtsetup generate rpi2
RUN $GOPATH/bin/qtsetup install rpi2
RUN cd $GOPATH/src/github.com/peterq/pan-light/qt/internal/examples/widgets/line_edits && $GOPATH/bin/qtdeploy build rpi2 && rm -rf ./deploy
