#upstream https://github.com/digitalocean/ceph_exporter
FROM ubuntu:16.04 as builder
MAINTAINER Vaibhav Bhembre <vaibhav@digitalocean.com>

ENV GOROOT /goroot
ENV GOPATH /go
ENV PATH $GOROOT/bin:$PATH
ENV APPLOC $GOPATH/src/github.com/digitalocean/ceph_exporter

RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-transport-https build-essential git curl wget && rm -rf /var/lib/apt/lists/*;

RUN wget -q -O- 'https://download.ceph.com/keys/release.asc' | apt-key add -
RUN echo "deb https://download.ceph.com/debian-luminous xenial main" >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get install --no-install-recommends -y --force-yes librados-dev librbd-dev && rm -rf /var/lib/apt/lists/*;

RUN \
  mkdir -p /goroot && \
  curl -f https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1

ADD . $APPLOC
WORKDIR $APPLOC
RUN go get -d && \
    go build -o /bin/ceph_exporter


FROM ubuntu:16.04
MAINTAINER Vaibhav Bhembre <vaibhav@digitalocean.com>

RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-transport-https curl wget && rm -rf /var/lib/apt/lists/*;
RUN wget -q -O- 'https://download.ceph.com/keys/release.asc' | apt-key add -
RUN echo "deb https://download.ceph.com/debian-luminous xenial main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y --force-yes librados2 librbd1 ceph-common && \
    rm -rf /var/lib/apt/lists/*


COPY --from=builder /bin/ceph_exporter /bin/ceph_exporter
RUN chmod +x /bin/ceph_exporter

EXPOSE 9128
ENTRYPOINT ["/bin/ceph_exporter"]
