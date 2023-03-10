FROM archlinux/base as base

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work

RUN pacman -Syyu --quiet || true
RUN pacman -S --noconfirm --needed --noprogressbar --quiet ca-certificates curl git tar
RUN GO=go1.13.4.linux-amd64.tar.gz && curl -f -sL --retry 10 --retry-delay 60 -O https://dl.google.com/go/$GO && tar -xzf $GO -C /usr/local
RUN /usr/local/go/bin/go get -tags=no_env github.com/therecipe/qt/cmd/...

FROM archlinux/base
LABEL maintainer therecipe

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work
ENV PATH /usr/local/go/bin:$PATH
ENV QT_API 5.13.0
ENV QT_DOCKER true
ENV QT_PKG_CONFIG true

COPY --from=base /usr/local/go /usr/local/go
COPY --from=base $GOPATH/bin $GOPATH/bin
COPY --from=base $GOPATH/src/github.com/therecipe/qt $GOPATH/src/github.com/therecipe/qt

RUN pacman -Syyu --quiet || true
RUN pacman -S --noconfirm --needed --noprogressbar --quiet base-devel glibc pkg-config && pacman -Scc --noconfirm --noprogressbar --quiet
RUN pacman -S --noconfirm --needed --noprogressbar --quiet qt5 && pacman -Scc --noconfirm --noprogressbar --quiet

RUN $GOPATH/bin/qtsetup prep
RUN $GOPATH/bin/qtsetup check
RUN $GOPATH/bin/qtsetup generate
RUN cd $GOPATH/src/github.com/therecipe/qt/internal/examples/widgets/line_edits && $GOPATH/bin/qtdeploy build linux && rm -rf ./deploy

RUN pacman -S --noconfirm --needed --noprogressbar --quiet ca-certificates git pkg-config