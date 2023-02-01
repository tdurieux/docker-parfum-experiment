FROM golang:1.17

WORKDIR /go/src/github.com/fault-lang/fault/

COPY . .

RUN apt-get update && \
apt-get -y upgrade && \
 apt-get install --no-install-recommends -y ca-certificates gcc && rm -rf /var/lib/apt/lists/*;

RUN go mod download

ENV SOLVERCMD=""
ENV SOLVERARG=""

RUN go build -o fcompiler .


