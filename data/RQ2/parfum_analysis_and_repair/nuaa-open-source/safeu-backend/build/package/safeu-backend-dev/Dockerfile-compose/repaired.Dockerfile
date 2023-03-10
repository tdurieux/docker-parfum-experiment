FROM golang:1.9.7

MAINTAINER TripleZ "me@triplez.cn"

# COPY conf/db.example.json $GOPATH/src/a2os/safeu-backend/conf/db.json

# Solution for Chinese special network enviornment 
# RUN mkdir -p $GOPATH/src/golang.org/x/ && \
# git clone https://github.com/golang/sys.git $GOPATH/src/golang.org/x/sys/
RUN mkdir -p $GOPATH/src/golang.org/x/ && \
    git clone https://gitee.com/Triple-Z/golang-sys.git $GOPATH/src/golang.org/x/sys/

# Add dependencies
RUN go get github.com/pilu/fresh

WORKDIR $GOPATH/src/a2os/safeu-backend
ADD . $GOPATH/src/a2os/safeu-backend/

# Build package
RUN go build -o safeu-backend-dev .

EXPOSE 8080

ENTRYPOINT ["fresh"]
# ENTRYPOINT ["./safeu-backend-dev"]