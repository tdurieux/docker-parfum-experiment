FROM centos:latest

RUN yum -y install git golang make nodejs \
    && npm install --global yarn && npm cache clean --force; && rm -rf /var/cache/yum
RUN git clone https://github.com/pyroscope-io/pyroscope.git
WORKDIR pyroscope
RUN ENABLED_SPIES="" \
    PATH=$PATH:$(go env GOPATH)/bin \
    make install-dev-tools install-web-dependencies \
    assets-release build test
