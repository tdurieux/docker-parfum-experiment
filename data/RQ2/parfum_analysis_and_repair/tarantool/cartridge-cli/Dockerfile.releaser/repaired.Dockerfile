FROM centos:7

ARG GOVERSION=1.15
ARG GORELEASER_VERSION=v0.138.0
# Packagecloud token is required for pkgcloud package that generates
# allowed disros list using token
ARG PACKAGECLOUD_TOKEN
ENV PACKAGECLOUD_TOKEN=${PACKAGECLOUD_TOKEN}

RUN mkdir -p ~/.gnupg \
    && echo 'digest-algo sha256' >> ~/.gnupg/gpg.conf

RUN yum -y update \
    && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum install -y procmail createrepo awscli reprepro pcre-tools bzip2 git && rm -rf /var/cache/yum

RUN curl -f -O -L https://dl.google.com/go/go${GOVERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf /go${GOVERSION}.linux-amd64.tar.gz && rm /go${GOVERSION}.linux-amd64.tar.gz

ENV PATH=${PATH}:/usr/local/go/bin
ENV GOPATH=/home/go
ENV PATH=$PATH:${GOPATH}/bin

RUN curl -f -O -L https://github.com/goreleaser/goreleaser/releases/download/${GORELEASER_VERSION}/goreleaser_amd64.rpm \
    && yum install -y goreleaser_amd64.rpm \
    && rm goreleaser_amd64.rpm \
    && go get -u -d github.com/magefile/mage \
    && cd $GOPATH/src/github.com/magefile/mage \
    && go run bootstrap.go && rm -rf /var/cache/yum

RUN go get -u -d github.com/mlafeldt/pkgcloud \
    && cd $GOPATH/src/github.com/mlafeldt/pkgcloud \
    && make generate && make all && cp pkgcloud-push $GOPATH/bin
