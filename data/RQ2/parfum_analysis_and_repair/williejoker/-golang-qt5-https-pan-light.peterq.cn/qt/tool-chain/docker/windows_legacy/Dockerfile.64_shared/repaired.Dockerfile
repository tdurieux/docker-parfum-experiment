FROM ubuntu:16.04 as base

RUN echo "deb http://pkg.mxe.cc/repos/apt/debian wheezy main" | tee --append /etc/apt/sources.list.d/mxeapt.list > /dev/null && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D43A795B73B16ABE9643FE1AFD8FFF16DB45C6AB && apt-get -qq update && apt-get --no-install-recommends -qq -y install mxe-x86-64-w64-mingw32.shared-qt3d mxe-x86-64-w64-mingw32.shared-qtactiveqt mxe-x86-64-w64-mingw32.shared-qtbase mxe-x86-64-w64-mingw32.shared-qtcanvas3d mxe-x86-64-w64-mingw32.shared-qtcharts mxe-x86-64-w64-mingw32.shared-qtconnectivity mxe-x86-64-w64-mingw32.shared-qtdatavis3d mxe-x86-64-w64-mingw32.shared-qtdeclarative mxe-x86-64-w64-mingw32.shared-qtgamepad mxe-x86-64-w64-mingw32.shared-qtgraphicaleffects mxe-x86-64-w64-mingw32.shared-qtimageformats mxe-x86-64-w64-mingw32.shared-qtlocation mxe-x86-64-w64-mingw32.shared-qtmultimedia mxe-x86-64-w64-mingw32.shared-qtofficeopenxml mxe-x86-64-w64-mingw32.shared-qtpurchasing mxe-x86-64-w64-mingw32.shared-qtquickcontrols mxe-x86-64-w64-mingw32.shared-qtquickcontrols2 mxe-x86-64-w64-mingw32.shared-qtscript mxe-x86-64-w64-mingw32.shared-qtscxml mxe-x86-64-w64-mingw32.shared-qtsensors mxe-x86-64-w64-mingw32.shared-qtserialbus mxe-x86-64-w64-mingw32.shared-qtserialport mxe-x86-64-w64-mingw32.shared-qtservice mxe-x86-64-w64-mingw32.shared-qtsvg mxe-x86-64-w64-mingw32.shared-qtsystems mxe-x86-64-w64-mingw32.shared-qttools mxe-x86-64-w64-mingw32.shared-qttranslations mxe-x86-64-w64-mingw32.shared-qtvirtualkeyboard mxe-x86-64-w64-mingw32.shared-qtwebchannel mxe-x86-64-w64-mingw32.shared-qtwebkit mxe-x86-64-w64-mingw32.shared-qtwebsockets mxe-x86-64-w64-mingw32.shared-qtwinextras mxe-x86-64-w64-mingw32.shared-qtxlsxwriter mxe-x86-64-w64-mingw32.shared-qtxmlpatterns && rm -rf /var/lib/apt/lists/*;


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
ENV QT_MXE_ARCH amd64
ENV QT_MXE_STATIC false

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
