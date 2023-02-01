FROM centos:7
ENV GOPATH=/go
RUN mkdir -p $GOPATH && \
	yum install -y build-essential golang git libseccomp-devel && rm -rf /var/cache/yum

RUN go get github.com/lizrice/strace-from-scratch
