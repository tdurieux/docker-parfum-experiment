FROM ubuntu:16.04 as base

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install ca-certificates curl git && rm -rf /var/lib/apt/lists/*;
RUN GO=go1.13.4.linux-amd64.tar.gz && curl -f -sL --retry 10 --retry-delay 60 -O https://dl.google.com/go/$GO && tar -xzf $GO -C /usr/local
RUN /usr/local/go/bin/go get -tags=no_env github.com/therecipe/qt/cmd/...

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install dbus fontconfig libx11-6 libx11-xcb1 && rm -rf /var/lib/apt/lists/*;
ENV QT qt-opensource-linux-x64-5.13.0.run
RUN curl -f -sL --retry 10 --retry-delay 60 -O https://download.qt.io/archive/qt/5.13/5.13.0/$QT && chmod +x $QT
RUN QT_QPA_PLATFORM=minimal ./$QT --no-force-installations --script $GOPATH/src/github.com/therecipe/qt/internal/ci/iscript.qs LINUX=true
RUN find /opt/Qt5.13.0/5.13.0 -type f -name "*.debug" -delete
RUN find /opt/Qt5.13.0/Docs -type f ! -name "*.index" -delete
RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install binutils && rm -rf /var/lib/apt/lists/*;
RUN find /opt/Qt5.13.0/5.13.0/gcc_64 -type f ! -name "*.a" ! -name "*.la" ! -name "*.prl" -name "lib*" -exec strip -s {} \;


FROM ubuntu:16.04
LABEL maintainer therecipe

ENV USER user
ENV HOME /home/$USER
ENV GOPATH $HOME/work
ENV PATH /usr/local/go/bin:$PATH
ENV QT_DIR /opt/Qt5.13.0
ENV QT_DOCKER true
ENV QT_VERSION 5.13.0

COPY --from=base /usr/local/go /usr/local/go
COPY --from=base $GOPATH/bin $GOPATH/bin
COPY --from=base $GOPATH/src/github.com/therecipe/qt $GOPATH/src/github.com/therecipe/qt
COPY --from=base /opt/Qt5.13.0/5.13.0 /opt/Qt5.13.0/5.13.0
COPY --from=base /opt/Qt5.13.0/Docs /opt/Qt5.13.0/Docs
COPY --from=base /opt/Qt5.13.0/Licenses /opt/Qt5.13.0/Licenses

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install build-essential libglib2.0-dev libglu1-mesa-dev libpulse-dev \
	&& apt-get --no-install-recommends -qq -y install fontconfig libasound2 libegl1-mesa libnss3 libpci3 libxcomposite1 libxcursor1 libxi6 libxrandr2 libxtst6 && apt-get -qq clean && apt-get -qq update && apt-get --no-install-recommends -qq -y install fcitx-frontend-qt5 && apt-get -qq clean && rm -rf /var/lib/apt/lists/*;

RUN $GOPATH/bin/qtsetup prep
RUN $GOPATH/bin/qtsetup check
RUN $GOPATH/bin/qtsetup generate
RUN cd $GOPATH/src/github.com/therecipe/qt/internal/examples/widgets/line_edits && $GOPATH/bin/qtdeploy build linux && rm -rf ./deploy

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install ca-certificates git pkg-config && rm -rf /var/lib/apt/lists/*;


ENV PATH $HOME/flutter/bin:$PATH

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install curl unzip && apt-get -qq clean && rm -rf /var/lib/apt/lists/*;
RUN git clone -q --depth 1 -b stable https://github.com/flutter/flutter.git $HOME/flutter
RUN flutter config --no-analytics && flutter precache --linux --no-android