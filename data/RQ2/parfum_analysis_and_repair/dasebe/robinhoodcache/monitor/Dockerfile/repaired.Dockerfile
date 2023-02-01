FROM golang:1.9

# Install basic applications
RUN apt-get update && apt-get install --no-install-recommends -y --fix-missing vim emacs-nox less telnet && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src
COPY ./src .
COPY ./start.sh .

WORKDIR /go/src/monitor
RUN go-wrapper download monitor   # "go get -d -v ./..."
RUN go-wrapper install monitor   # "go install -v ./..."

WORKDIR /go/src

CMD ./start.sh
