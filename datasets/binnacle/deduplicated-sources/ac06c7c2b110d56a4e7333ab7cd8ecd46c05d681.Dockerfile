FROM debian:stretch

MAINTAINER seu <seu@panopticon.re>

RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
        qt5-default qtdeclarative5-dev \
	qml-module-qtquick-controls qml-module-qttest \
	qml-module-qtquick2 qml-module-qtquick-layouts \
	qml-module-qtgraphicaleffects \
	libqt5svg5-dev qtbase5-private-dev pkg-config \
	libglpk-dev git build-essential cmake \
  git dpkg-dev lintian debhelper cdbs file curl

COPY entrypoint.sh /entrypoint.sh
COPY rustup.sh /tmp/rustup.sh

ENV PANOPTICON_URL="https://github.com/das-labor/panopticon"
ENV PANOPTICON_BRANCH="master"

CMD /entrypoint.sh
