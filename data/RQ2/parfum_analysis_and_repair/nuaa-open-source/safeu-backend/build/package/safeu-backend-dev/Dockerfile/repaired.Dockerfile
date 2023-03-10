FROM golang:1.9.7

MAINTAINER TripleZ "me@triplez.cn"

WORKDIR $GOPATH/src/a2os/safeu-backend
ADD . $GOPATH/src/a2os/safeu-backend/

# Solution for Chinese special network enviornment 
# RUN mkdir -p $GOPATH/src/golang.org/x/ && \
#     git clone https://github.com/golang/sys.git $GOPATH/src/golang.org/x/sys/
RUN mkdir -p $GOPATH/src/golang.org/x/ && \
    git clone https://gitee.com/Triple-Z/golang-sys.git $GOPATH/src/golang.org/x/sys/

# Add dependencies
# RUN go get -u github.com/kardianos/govendor && go get github.com/pilu/fresh && govendor sync

# Add fresh package
RUN go get github.com/pilu/fresh

# Build package
RUN go build .

EXPOSE 8080

ENTRYPOINT ["fresh"]
#ENTRYPOINT ["./safeu-backend-dev"]