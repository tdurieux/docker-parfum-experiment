FROM golang:1.13

COPY . /go-fsevents

WORKDIR /go-fsevents
RUN go mod download

ENV GOPATH="/go"

RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=1 go build -o example-handlers -v ./examples/handlers

RUN mkdir /watch
CMD ./example-handlers /watch