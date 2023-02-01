FROM --platform=linux/amd64 golang:1.17.0-buster

COPY scripts/install-debian-mongo.sh ./install-debian-mongo.sh
RUN apt-get update && apt-get install --no-install-recommends -y netcat git libsasl2-dev && ./install-debian-mongo.sh && rm -rf /var/lib/apt/lists/*;

WORKDIR /oplogtoredis

COPY main.go go.mod go.sum ./
COPY lib ./lib

RUN go build -o /bin/oplogtoredis

ADD scripts/wait-for.sh /wait-for.sh
ADD blackbox-tests/oplogtoredis-entry.sh /oplogtoredis-entry.sh
