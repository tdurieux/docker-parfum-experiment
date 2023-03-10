FROM clickable/ubuntu-sdk:16.04-amd64
LABEL maintainer therecipe

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work
ENV PATH /usr/local/go/bin:$PATH
ENV QT_DOCKER true
ENV QT_PKG_CONFIG true
ENV QT_UBPORTS true
ENV QT_UBPORTS_ARCH amd64
ENV QT_UBPORTS_VERSION xenial

RUN rm -rf /usr/local/go || true
COPY --from=therecipe/qt:linux /usr/local/go /usr/local/go
COPY --from=therecipe/qt:linux $GOPATH/bin $GOPATH/bin
COPY --from=therecipe/qt:linux $GOPATH/src/github.com/peterq/pan-light/qt $GOPATH/src/github.com/peterq/pan-light/qt

RUN $GOPATH/bin/qtsetup prep
RUN $GOPATH/bin/qtsetup check ubports
RUN $GOPATH/bin/qtsetup generate ubports
RUN $GOPATH/bin/qtsetup install ubports