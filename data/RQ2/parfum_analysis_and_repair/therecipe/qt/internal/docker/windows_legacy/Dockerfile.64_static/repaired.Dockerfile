FROM ubuntu:16.04 as base

RUN echo "deb http://pkg.mxe.cc/repos/apt trusty main" | tee --append /etc/apt/sources.list.d/mxeapt.list > /dev/null && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 86B72ED9 && apt-get -qq update && apt-get --no-install-recommends -qq -y install mxe-x86-64-w64-mingw32.static-qt3d mxe-x86-64-w64-mingw32.static-qtactiveqt mxe-x86-64-w64-mingw32.static-qtbase mxe-x86-64-w64-mingw32.static-qtcanvas3d mxe-x86-64-w64-mingw32.static-qtcharts mxe-x86-64-w64-mingw32.static-qtconnectivity mxe-x86-64-w64-mingw32.static-qtdatavis3d mxe-x86-64-w64-mingw32.static-qtdeclarative mxe-x86-64-w64-mingw32.static-qtgamepad mxe-x86-64-w64-mingw32.static-qtgraphicaleffects mxe-x86-64-w64-mingw32.static-qtimageformats mxe-x86-64-w64-mingw32.static-qtlocation mxe-x86-64-w64-mingw32.static-qtmultimedia mxe-x86-64-w64-mingw32.static-qtofficeopenxml mxe-x86-64-w64-mingw32.static-qtpurchasing mxe-x86-64-w64-mingw32.static-qtquickcontrols mxe-x86-64-w64-mingw32.static-qtquickcontrols2 mxe-x86-64-w64-mingw32.static-qtscript mxe-x86-64-w64-mingw32.static-qtscxml mxe-x86-64-w64-mingw32.static-qtsensors mxe-x86-64-w64-mingw32.static-qtserialbus mxe-x86-64-w64-mingw32.static-qtserialport mxe-x86-64-w64-mingw32.static-qtservice mxe-x86-64-w64-mingw32.static-qtsvg mxe-x86-64-w64-mingw32.static-qtsystems mxe-x86-64-w64-mingw32.static-qttools mxe-x86-64-w64-mingw32.static-qttranslations mxe-x86-64-w64-mingw32.static-qtvirtualkeyboard mxe-x86-64-w64-mingw32.static-qtwebchannel mxe-x86-64-w64-mingw32.static-qtwebsockets mxe-x86-64-w64-mingw32.static-qtwinextras mxe-x86-64-w64-mingw32.static-qtxlsxwriter mxe-x86-64-w64-mingw32.static-qtxmlpatterns && rm -rf /var/lib/apt/lists/*;


FROM ubuntu:16.04
LABEL maintainer therecipe

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work
ENV PATH /usr/lib/mxe/usr/bin:/usr/local/go/bin:$PATH
ENV QT_API 5.12.0
ENV QT_DOCKER true
ENV QT_MXE true
ENV QT_MXE_ARCH amd64
ENV QT_MXE_STATIC true

COPY --from=therecipe/qt:linux /usr/local/go /usr/local/go
COPY --from=therecipe/qt:linux $GOPATH/bin $GOPATH/bin
COPY --from=therecipe/qt:linux $GOPATH/src/github.com/therecipe/qt $GOPATH/src/github.com/therecipe/qt
COPY --from=base /usr/lib/mxe /usr/lib/mxe

RUN $GOPATH/bin/qtsetup prep
RUN $GOPATH/bin/qtsetup check windows
RUN $GOPATH/bin/qtsetup generate windows
RUN $GOPATH/bin/qtsetup install windows
RUN cd $GOPATH/src/github.com/therecipe/qt/internal/examples/widgets/line_edits && sed -i -e 's/AddWidget2/AddWidget/g' line_edits.go && $GOPATH/bin/qtdeploy build windows && rm -rf ./deploy

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install ca-certificates git pkg-config && rm -rf /var/lib/apt/lists/*;