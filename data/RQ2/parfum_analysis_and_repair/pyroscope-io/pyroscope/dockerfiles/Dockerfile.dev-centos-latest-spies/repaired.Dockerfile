FROM centos:latest

RUN yum -y install git golang make nodejs \
    && yum -y install php-devel cargo rustc \
    && npm install --global yarn && npm cache clean --force; && rm -rf /var/cache/yum
RUN git clone https://github.com/pyroscope-io/pyroscope.git
WORKDIR pyroscope
RUN PATH=$PATH:$(go env GOPATH)/bin \
    make install-dev-tools install-web-dependencies \
    build-third-party-dependencies \
    assets-release build test
