FROM ubuntu:16.04 as base

RUN echo "deb http://pkg.mxe.cc/repos/apt/debian wheezy main" | tee --append /etc/apt/sources.list.d/mxeapt.list > /dev/null && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D43A795B73B16ABE9643FE1AFD8FFF16DB45C6AB && apt-get -qq update && apt-get --no-install-recommends -qq -y install mxe-i686-w64-mingw32.static-qt3d mxe-i686-w64-mingw32.static-qtactiveqt mxe-i686-w64-mingw32.static-qtbase mxe-i686-w64-mingw32.static-qtcanvas3d mxe-i686-w64-mingw32.static-qtcharts mxe-i686-w64-mingw32.static-qtconnectivity mxe-i686-w64-mingw32.static-qtdatavis3d mxe-i686-w64-mingw32.static-qtdeclarative mxe-i686-w64-mingw32.static-qtgamepad mxe-i686-w64-mingw32.static-qtgraphicaleffects mxe-i686-w64-mingw32.static-qtimageformats mxe-i686-w64-mingw32.static-qtlocation mxe-i686-w64-mingw32.static-qtmultimedia mxe-i686-w64-mingw32.static-qtofficeopenxml mxe-i686-w64-mingw32.static-qtpurchasing mxe-i686-w64-mingw32.static-qtquickcontrols mxe-i686-w64-mingw32.static-qtquickcontrols2 mxe-i686-w64-mingw32.static-qtscript mxe-i686-w64-mingw32.static-qtscxml mxe-i686-w64-mingw32.static-qtsensors mxe-i686-w64-mingw32.static-qtserialbus mxe-i686-w64-mingw32.static-qtserialport mxe-i686-w64-mingw32.static-qtservice mxe-i686-w64-mingw32.static-qtsvg mxe-i686-w64-mingw32.static-qtsystems mxe-i686-w64-mingw32.static-qttools mxe-i686-w64-mingw32.static-qttranslations mxe-i686-w64-mingw32.static-qtvirtualkeyboard mxe-i686-w64-mingw32.static-qtwebchannel mxe-i686-w64-mingw32.static-qtwebsockets mxe-i686-w64-mingw32.static-qtwinextras mxe-i686-w64-mingw32.static-qtxlsxwriter mxe-i686-w64-mingw32.static-qtxmlpatterns && rm -rf /var/lib/apt/lists/*;


FROM ubuntu:16.04
LABEL maintainer therecipe

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work
ENV PATH /usr/lib/mxe/usr/bin:/usr/local/go/bin:$PATH
ENV QT_API 5.8.0
ENV QT_DIR /opt/Qt
ENV QT_DOCKER true
ENV QT_MXE true
ENV QT_MXE_ARCH 386
ENV QT_MXE_STATIC true

COPY --from=therecipe/qt:linux /usr/local/go /usr/local/go
COPY --from=therecipe/qt:linux $GOPATH/bin $GOPATH/bin
COPY --from=therecipe/qt:linux $GOPATH/src/github.com/peterq/pan-light/qt $GOPATH/src/github.com/peterq/pan-light/qt
COPY --from=therecipe/qt:linux /opt/Qt/5.12.0/gcc_64/include /opt/Qt/5.12.0/gcc_64/include
COPY --from=base /usr/lib/mxe /usr/lib/mxe

RUN $GOPATH/bin/qtsetup prep
RUN $GOPATH/bin/qtsetup check windows
RUN $GOPATH/bin/qtsetup generate windows
RUN $GOPATH/bin/qtsetup install windows
RUN cd $GOPATH/src/github.com/peterq/pan-light/qt/internal/examples/widgets/line_edits && $GOPATH/bin/qtdeploy build windows && rm -rf ./deploy
