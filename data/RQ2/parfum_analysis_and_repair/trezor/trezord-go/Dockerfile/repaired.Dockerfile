FROM golang:latest

RUN mkdir /trezord-go
WORKDIR /trezord-go
COPY ./scripts/run_in_docker.sh /trezord-go

RUN apt-get update && apt-get install --no-install-recommends -y redir && rm -rf /var/lib/apt/lists/*;

RUN go get github.com/trezor/trezord-go
RUN go build github.com/trezor/trezord-go

ENTRYPOINT '/trezord-go/run_in_docker.sh'
EXPOSE 11325
