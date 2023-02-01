FROM debian:jessie

VOLUME /output

RUN apt-get -yqq update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -yqq install \
        dpkg-dev \
        lsb-release \
        curl \
        git \
        wget \
        make \
        unzip \
        ruby-dev \
        rubygems \
        python-dev \
        python-pip && rm -rf /var/lib/apt/lists/*;

RUN gem install fpm
RUN pip install --no-cache-dir virtualenv

RUN mkdir -p /gocode/src/github.com/uber/peloton
WORKDIR /gocode/src/github.com/uber/peloton

RUN curl -f -o go1.11.4.linux-amd64.tar.gz https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.11.4.linux-amd64.tar.gz && rm go1.11.4.linux-amd64.tar.gz

ENV PATH="${PATH}:/usr/local/go/bin"
ENV GOROOT=/usr/local/go
ENV GOBIN=/usr/local/go/bin
ENV GOPATH=/gocode
ENV SRC_DIR=/gocode/src/github.com/uber/peloton

RUN curl -f https://glide.sh/get | sh

ADD . /gocode/src/github.com/uber/peloton

RUN rm -rf vendor && glide cc && glide install

ADD tools/packaging/peloton-release/deb/jessie/build.sh /build.sh
ADD tools/packaging/peloton-release/deb/build-common.sh /build-common.sh
ENTRYPOINT ["/build.sh"]
