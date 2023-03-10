FROM fedora:latest

RUN dnf -y install git golang make nodejs \
    && dnf -y install cargo libunwind-devel php-devel \
    && npm install --global yarn && npm cache clean --force;
RUN git clone https://github.com/pyroscope-io/pyroscope.git
WORKDIR pyroscope
RUN PATH=$PATH:$(go env GOPATH)/bin \
    make install-dev-tools install-web-dependencies \
    build-third-party-dependencies \
    assets-release build test
