FROM golang:1.10

# install sqlite3 for option "-console"
RUN apt-get update && apt-get install --no-install-recommends -y sqlite3 && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src/app
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

WORKDIR /tmp

ENTRYPOINT ["textql"]
