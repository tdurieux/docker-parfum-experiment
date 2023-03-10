FROM therecipe/qt:linux as base

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install ca-certificates git && rm -rf /var/lib/apt/lists/*;

RUN mv /usr/local/go /usr/local/go_orig
RUN git clone -q --depth 1 -b wasm-sync-callbacks https://github.com/neelance/go.git /usr/local/go
RUN cd /usr/local/go/src && GOROOT_BOOTSTRAP=/usr/local/go_orig ./make.bash


FROM ubuntu:16.04
LABEL maintainer therecipe

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work
ENV PATH /usr/local/go/bin:$PATH
ENV QT_DIR /opt/Qt
ENV QT_DOCKER true
ENV QT_QMAKE_DIR /usr/local/Qt-5.12.0/bin

COPY --from=base /usr/local/go /usr/local/go
COPY --from=therecipe/qt:linux $GOPATH/bin $GOPATH/bin
COPY --from=therecipe/qt:linux $GOPATH/src/github.com/peterq/pan-light/qt $GOPATH/src/github.com/peterq/pan-light/qt
COPY --from=therecipe/qt:linux /opt/Qt/5.12.0/gcc_64/include /opt/Qt/5.12.0/gcc_64/include
COPY --from=therecipe/qt:linux /opt/Qt/Docs /opt/Qt/Docs
COPY --from=therecipe/qt:js_base $HOME/emsdk $HOME/emsdk
COPY --from=therecipe/qt:js_base $HOME/.emscripten $HOME/.emscripten
COPY --from=therecipe/qt:js_base /usr/local/Qt-5.12.0 /usr/local/Qt-5.12.0

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install python2.7 nodejs cmake default-jre && apt-get -qq clean && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/python2.7 /usr/bin/python

RUN $GOPATH/bin/qtsetup prep
RUN $GOPATH/bin/qtsetup check wasm
RUN QT_STUB=true $GOPATH/bin/qtsetup generate
RUN $GOPATH/bin/qtsetup generate wasm
RUN $GOPATH/bin/qtsetup install wasm
RUN cd $GOPATH/src/github.com/peterq/pan-light/qt/internal/examples/widgets/line_edits && $GOPATH/bin/qtdeploy build wasm && rm -rf ./deploy
