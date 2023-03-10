FROM ubuntu:16.04
LABEL maintainer therecipe

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work
ENV PATH /usr/local/go/bin:$PATH
ENV QT_DIR /opt/Qt
ENV QT_DOCKER true
ENV QT_RPI true
ENV QT_QMAKE_DIR /opt/qtrpi/raspi/qt5/bin
ENV RPI_TOOLS_DIR /opt/qtrpi/raspi/tools
ENV RPI_COMPILER gcc-linaro-arm-linux-gnueabihf-raspbian-x64

COPY --from=therecipe/qt:linux /usr/local/go /usr/local/go
COPY --from=therecipe/qt:linux $GOPATH/bin $GOPATH/bin
COPY --from=therecipe/qt:linux $GOPATH/src/github.com/peterq/pan-light/qt $GOPATH/src/github.com/peterq/pan-light/qt
COPY --from=therecipe/qt:linux /opt/Qt/5.12.0/gcc_64/include /opt/Qt/5.12.0/gcc_64/include

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install ca-certificates curl git make unzip && apt-get -qq clean && rm -rf /var/lib/apt/lists/*;

RUN SYSROOT=qtrpi-sysroot-minimal-latest.zip && curl -f -sL --retry 10 --retry-delay 60 -O http://www.qtrpi.com/downloads/sysroot/$SYSROOT && unzip -qq $SYSROOT -d /opt/qtrpi && rm -f $SYSROOT
RUN ln -s /opt/qtrpi/raspbian/sysroot-minimal /opt/qtrpi/raspbian/sysroot

RUN git clone -q --depth 1 https://github.com/raspberrypi/tools.git /opt/qtrpi/raspi/tools

RUN $GOPATH/bin/qtsetup prep
