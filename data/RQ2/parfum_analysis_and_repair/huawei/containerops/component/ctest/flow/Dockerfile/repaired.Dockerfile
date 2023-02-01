FROM docker.io/phusion/baseimage:0.9.21
MAINTAINER dian.li <lidian@huawei.com>
RUN apt-get update && apt-get install --no-install-recommends -y tar git golang && rm -rf /var/lib/apt/lists/*;
WORKDIR /var/opt/gopath/src
ENV GOPATH /var/opt/gopath
ENV PATH $PATH:$GOROOT/bin:$GOPATH:/bin
COPY component-auto-flow.sh component-auto-flow.sh
CMD ./component-auto-flow.sh


