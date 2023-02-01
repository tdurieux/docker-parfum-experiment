FROM centos:7
WORKDIR /var/tmp
ENTRYPOINT ["/sbin/init"]
RUN yum install -y yum-utils && rm -rf /var/cache/yum
# epel-release.rpm from CentOS/extra contains deprecated index for mirror sites.
RUN yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm && rm -rf /var/cache/yum
RUN yum install -y git createrepo && rm -rf /var/cache/yum

RUN curl -f -L https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz | tar -C /usr/local -xzf -
RUN yum install -y gcc && rm -rf /var/cache/yum
ENV GOPATH=/var/tmp/go PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
RUN mkdir $GOPATH
RUN go get -u github.com/kardianos/govendor
RUN mkdir -p /var/tmp/go/src/github.com/axsh/openvdc
RUN mkdir -p /var/tmp/rpmbuild/SOURCES
RUN ln -s ${GOPATH}/src/github.com/axsh/openvdc  /var/tmp/rpmbuild/SOURCES/openvdc
ENV WORK_DIR=/var/tmp/rpmbuild
