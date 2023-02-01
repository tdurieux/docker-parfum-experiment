FROM golang:1.9.2

ENV SRC_DIR=/go/src/github.com/arpitaggarwal/
ENV GOBIN=/go/bin

WORKDIR $GOBIN

ADD . $SRC_DIR

RUN cd /go/src/;
RUN go get github.com/go-sql-driver/mysql;
RUN go get github.com/gorilla/mux;

RUN go install github.com/arpitaggarwal/;
ENTRYPOINT ["./arpitaggarwal"]

EXPOSE 8080
