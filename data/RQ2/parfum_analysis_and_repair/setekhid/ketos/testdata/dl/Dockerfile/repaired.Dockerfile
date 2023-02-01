FROM centos:7
RUN yum install -y golang build-essential make git && \
	mkdir -p /go/src && rm -rf /var/cache/yum

ADD . /go/src/

RUN export GOPATH=/go && \
	go get github.com/rainycape/dl && \
	cd $GOPATH/src && \
	go build -o ./main . && \
	./main
