FROM golang:1.17

WORKDIR /go/src/github.com/magunetto/moviemagnetbot
COPY . .

RUN cd cmd/moviemagnetbot && go build

CMD ["./cmd/moviemagnetbot/moviemagnetbot"]
