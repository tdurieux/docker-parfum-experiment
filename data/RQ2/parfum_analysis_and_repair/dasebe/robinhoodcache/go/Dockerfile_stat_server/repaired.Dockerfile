FROM golang:1.9

# Install basic applications
RUN apt-get update && apt-get install --no-install-recommends -y --fix-missing vim emacs-nox less telnet htop && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src
COPY ./src .
COPY ./start_stat_server.sh .

WORKDIR /go/src/statserver
RUN go-wrapper download statserver   # "go get -d -v ./..."
RUN go-wrapper install statserver   # "go install -v ./..."

WORKDIR /go/src

CMD ./start_stat_server.sh
