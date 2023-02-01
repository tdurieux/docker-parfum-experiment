FROM golang:1.8

# Install basic applications
RUN apt-get update && apt-get install --no-install-recommends -y --fix-missing vim less telnet && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src
COPY ./src .
COPY ./start_fback.sh .

WORKDIR /go/src/fback
RUN go-wrapper download fback   # "go get -d -v ./..."
RUN go-wrapper install fback   # "go install -v ./..."

WORKDIR /go/src

CMD ./start_fback.sh
