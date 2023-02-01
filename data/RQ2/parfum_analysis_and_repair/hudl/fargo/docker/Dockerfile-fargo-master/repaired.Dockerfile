FROM golang:1.16

RUN go get github.com/tools/godep

RUN git clone https://github.com/hudl/fargo.git /usr/local/src/fargo

WORKDIR /usr/local/src/fargo

RUN go mod download