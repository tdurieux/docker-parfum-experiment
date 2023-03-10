FROM golang:1.9

RUN go get github.com/githubnemo/CompileDaemon
RUN go get github.com/lib/pq

COPY . /go/src/github.com/bsdavidson/trimetric/
RUN go install github.com/bsdavidson/trimetric/cmd/trimetric

VOLUME ["/go/src/github.com/bsdavidson/trimetric"]
EXPOSE 80

CMD [ "/go/bin/trimetric" ]