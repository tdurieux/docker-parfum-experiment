FROM inspursoft/golang-mips:1.12.9

MAINTAINER huay@inspur.com

COPY src/. /go/src/git/inspursoft/board/src/.

WORKDIR /go/src/git/inspursoft/board/src/tokenserver

RUN go build -v -a -o /go/bin/tokenserver

RUN chmod u+x /go/bin/tokenserver

WORKDIR /go/bin/

ENTRYPOINT ["/go/bin/tokenserver"]

VOLUME ["/go/bin"]

EXPOSE 4000