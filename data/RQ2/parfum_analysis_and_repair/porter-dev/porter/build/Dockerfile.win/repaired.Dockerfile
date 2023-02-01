ARG GO_VERSION=1.18

FROM golang:${GO_VERSION}

RUN apt-get update && apt-get install --no-install-recommends -y zip unzip && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src/github.com/docker/cli
COPY    . .

ENV GOOS windows
ENV GOARCH amd64

RUN chmod +x ./scripts/build/win.sh

ENTRYPOINT [ "./scripts/build/win.sh" ]