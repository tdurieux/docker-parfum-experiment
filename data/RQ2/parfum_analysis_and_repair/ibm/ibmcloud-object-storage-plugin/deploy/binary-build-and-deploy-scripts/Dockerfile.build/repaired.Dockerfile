FROM ubuntu:16.04

RUN apt-get update -q && apt-get install --no-install-recommends -q -y ca-certificates git-core make curl software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y automake autotools-dev fuse g++ git libcurl4-openssl-dev libfuse-dev libssl-dev libxml2-dev make pkg-config && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/

RUN  add-apt-repository ppa:masterminds/glide -y && apt-get update -q
RUN apt-get install -y --no-install-recommends -q glide && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://storage.googleapis.com/golang/go1.9.4.linux-amd64.tar.gz | tar -C /usr/local -xz

ADD  compile-plugin.sh /root
ADD  compile-s3fs.sh /root

RUN  chmod 755 /root/compile-plugin.sh /root/compile-s3fs.sh

ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH /usr/local/go/bin:/go/bin:/usr/local/bin:$PATH

WORKDIR /root/

CMD ["/bin/bash"]
