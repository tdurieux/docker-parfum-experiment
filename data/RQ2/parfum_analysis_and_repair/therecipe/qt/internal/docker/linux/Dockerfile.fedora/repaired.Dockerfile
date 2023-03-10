FROM fedora:latest as base

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work

RUN yum makecache && yum --skip-broken -y install git && rm -rf /var/cache/yum
RUN GO=go1.13.4.linux-amd64.tar.gz && curl -f -sL --retry 10 --retry-delay 60 -O https://dl.google.com/go/$GO && tar -xzf $GO -C /usr/local
RUN /usr/local/go/bin/go get -tags=no_env github.com/therecipe/qt/cmd/...

FROM fedora:latest
LABEL maintainer therecipe

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work
ENV PATH /usr/local/go/bin:$PATH
ENV QT_API 5.12.0
ENV QT_DOCKER true
ENV QT_PKG_CONFIG true

COPY --from=base /usr/local/go /usr/local/go
COPY --from=base $GOPATH/bin $GOPATH/bin
COPY --from=base $GOPATH/src/github.com/therecipe/qt $GOPATH/src/github.com/therecipe/qt

RUN yum makecache && yum -y groupinstall "C Development Tools and Libraries" && yum clean all
RUN yum makecache && yum --skip-broken -y install mesa-libGLU-devel gstreamer-plugins-base pulseaudio-libs-devel glib2-devel && yum clean all && rm -rf /var/cache/yum
RUN yum makecache && yum --skip-broken -y install qt5-* qt5-*-doc && yum clean all && rm -rf /var/cache/yum

RUN $GOPATH/bin/qtsetup prep
RUN $GOPATH/bin/qtsetup check
RUN $GOPATH/bin/qtsetup generate
RUN cd $GOPATH/src/github.com/therecipe/qt/internal/examples/widgets/line_edits && sed -i -e 's/AddWidget2/AddWidget/g' line_edits.go && $GOPATH/bin/qtdeploy build linux && rm -rf ./deploy

RUN yum makecache && yum --skip-broken -y install git pkg-config && rm -rf /var/cache/yum