FROM golang:1.17

RUN apt-get update && apt-get install --no-install-recommends -y inotify-tools && rm -rf /var/lib/apt/lists/*;

ENV ROOT_PATH /go/src/github.com/get-woke/woke
WORKDIR $ROOT_PATH
COPY go.mod ./
COPY go.sum ./

RUN go mod download

ENTRYPOINT ["./dev/autoreload.sh"]
