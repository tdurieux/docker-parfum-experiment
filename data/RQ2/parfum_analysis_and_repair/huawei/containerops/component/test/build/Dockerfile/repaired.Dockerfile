FROM docker.io/phusion/baseimage:0.9.21
MAINTAINER dian.li <lidian@huawei.com>
RUN apt-get update && apt-get install --no-install-recommends -y tar git golang && rm -rf /var/lib/apt/lists/*;
WORKDIR /var/opt/gopath/src/github.com/Huawei/
ENV GOPATH /var/opt/gopath
ENV PATH $PATH:$GOROOT/bin:$GOPATH:/bin
RUN git clone https://github.com/Huawei/containerops.git
WORKDIR containerops/component/ctest/build
RUN go get
ADD main.go main.go
ADD module module
RUN go build main.go
COPY component-auto-tar.sh component-auto-tar.sh
RUN ./component-auto-tar.sh
CMD main


