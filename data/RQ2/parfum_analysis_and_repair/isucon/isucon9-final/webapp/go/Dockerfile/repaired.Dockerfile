FROM golang:1.12

RUN apt-get update && apt-get -y --no-install-recommends install mariadb-client && rm -rf /var/lib/apt/lists/*;

ENV GO111MODULE=on

WORKDIR /go/src/webapp
CMD ["go", "run", "main.go", "utils.go"]
