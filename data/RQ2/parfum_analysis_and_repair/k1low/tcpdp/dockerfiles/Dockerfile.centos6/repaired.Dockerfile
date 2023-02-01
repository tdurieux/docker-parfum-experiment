FROM centos:6
LABEL maintainer="k1LoW <k1lowxb@gmail.com>"

ARG GO_VERSION
ARG LIBPCAP_VERSION

RUN sed -i -e "s/^mirrorlist=http:\/\/mirrorlist.centos.org/#mirrorlist=http:\/\/mirrorlist.centos.org/g" /etc/yum.repos.d/CentOS-Base.repo &&\
RUN sed -i -e "s/^#baseurl=http:\/\/mirror.centos.org/baseurl=http:\/\/vault.centos.org/g" /etc/yum.repos.d/CentOS-Base.repo
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y rpmdevtools yum-utils make glibc glibc-static gcc byacc flex bison libpcap-devel \
    curl-devel expat-devel gettext-devel openssl-devel perl-devel zlib-devel perl-ExtUtils-MakeMaker && rm -rf /var/cache/yum
RUN cd /usr/local/src/ &&\
       curl -LkvOf https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.33.0.tar.gz && \
       tar zvfx git-2.33.0.tar.gz && rm git-2.33.0.tar.gz
RUN cd git-git-2.33.0 && make prefix=/usr/local all && make prefix=/usr/local install

ENV FILE go$GO_VERSION.linux-amd64.tar.gz
ENV URL https://storage.googleapis.com/golang/$FILE
ENV LIBPCAP_VERSION $LIBPCAP_VERSION
ENV LIBPCAP_FILE libpcap-$LIBPCAP_VERSION.tar.gz
ENV LIBPCAP_URL https://www.tcpdump.org/release/$LIBPCAP_FILE

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN set -eux &&\
  yum -y clean all && \
  curl -f -OL $URL && \
	tar -C /usr/local -xzf $FILE && \
	rm $FILE && \
  curl -f -OL $LIBPCAP_URL && \
	tar -C /usr/local/src -xzf $LIBPCAP_FILE && \
	rm $LIBPCAP_FILE && \
  mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

ADD . /go/src/github.com/k1LoW/tcpdp
WORKDIR /go/src/github.com/k1LoW/tcpdp
