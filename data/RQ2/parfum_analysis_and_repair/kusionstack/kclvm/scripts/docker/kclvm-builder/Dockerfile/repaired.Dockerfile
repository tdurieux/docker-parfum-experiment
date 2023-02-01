# Copyright 2021 The KCL Authors. All rights reserved.

FROM ubuntu:20.04

#RUN uname -a
#RUN cat /etc/os-release

RUN apt-get update

RUN apt-get install --no-install-recommends -y git wget curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y make gcc patch g++ swig && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev libffi-dev && rm -rf /var/lib/apt/lists/*;
# SSL module deps sed by python3
RUN apt-get install --no-install-recommends -y zlib1g-dev ncurses-dev build-essential libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev && rm -rf /var/lib/apt/lists/*;

# python-3.9
RUN mkdir -p /root/download && cd /root/download \
  && wget https://npm.taobao.org/mirrors/python/3.9.10/Python-3.9.10.tgz \
  && tar -xzf Python-3.9.10.tgz \
  && cd Python-3.9.10 \
  && LANG=C.UTF-8 ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
      --prefix=/usr/local/python3.9 \
      --enable-optimizations \
      --with-ssl \
  && make install && rm Python-3.9.10.tgz
RUN ln -sf /usr/local/python3.9/bin/python3.9 /usr/bin/python3
RUN ln -sf /usr/local/python3.9/bin/python3.9 /usr/bin/python3.9

# rust
# https://www.rust-lang.org/tools/install
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

RUN cargo version
RUN rustc --version

# wasm
RUN rustup target add wasm32-unknown-unknown

# clang12
RUN apt-get install --no-install-recommends -y clang-12 lld-12 && rm -rf /var/lib/apt/lists/*;
RUN ln -sf /usr/bin/clang-12   /usr/bin/clang
RUN ln -sf /usr/bin/wasm-ld-12 /usr/bin/wasm-ld

# golang 1.17+
RUN mkdir -p /root/download && cd /root/download \
  && wget https://dl.google.com/go/go1.17.3.linux-amd64.tar.gz \
  && tar -zxvf go1.17.3.linux-amd64.tar.gz \
  && mv ./go /usr/local/go1.17.3 && rm go1.17.3.linux-amd64.tar.gz
RUN ln -sf /usr/local/go1.17.3/bin/go /usr/bin/go
RUN rm -rf /root/download

ENV GOPATH=/go
ENV GOLANG_VERSION=1.17.3

RUN go get golang.org/x/lint/golint
RUN go get golang.org/x/tools/cmd/goimports
RUN go get honnef.co/go/tools/cmd/...

RUN go get github.com/t-yuki/gocover-cobertura
RUN go get github.com/jstemmer/go-junit-report

RUN rm -rf /go/pkg/mod
RUN rm -rf /go/pkg/sumdb

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone

WORKDIR /root

CMD ["bash"]
