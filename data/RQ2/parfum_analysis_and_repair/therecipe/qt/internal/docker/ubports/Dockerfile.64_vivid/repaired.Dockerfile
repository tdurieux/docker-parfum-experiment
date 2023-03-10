FROM clickable/ubuntu-sdk:15.04-amd64
LABEL maintainer therecipe

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work
ENV PATH /usr/local/go/bin:$PATH
ENV QT_DOCKER true
ENV QT_PKG_CONFIG true
ENV QT_UBPORTS true
ENV QT_UBPORTS_ARCH amd64
ENV QT_UBPORTS_VERSION vivid

RUN rm -rf /usr/local/go || true
COPY --from=therecipe/qt:linux /usr/local/go /usr/local/go
COPY --from=therecipe/qt:linux $GOPATH/bin $GOPATH/bin
COPY --from=therecipe/qt:linux $GOPATH/src/github.com/therecipe/qt $GOPATH/src/github.com/therecipe/qt

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install qt*5-doc-html && apt-get -qq clean && rm -rf /var/lib/apt/lists/*;

RUN $GOPATH/bin/qtsetup prep
RUN $GOPATH/bin/qtsetup check ubports
RUN $GOPATH/bin/qtsetup generate ubports
RUN $GOPATH/bin/qtsetup install ubports
RUN cd $GOPATH/src/github.com/therecipe/qt/internal/examples/ubports/view && $GOPATH/bin/qtdeploy build ubports && rm -rf ./deploy

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install ca-certificates git pkg-config && rm -rf /var/lib/apt/lists/*;