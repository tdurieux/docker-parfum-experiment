FROM ubuntu

# Install the C lib for kafka
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils wget gnupg software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN wget -qO - https://packages.confluent.io/deb/5.1/archive.key | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://packages.confluent.io/deb/5.1 stable main"
RUN apt-get update
RUN apt-get install --no-install-recommends -y librdkafka-dev && rm -rf /var/lib/apt/lists/*;

# Install Go
RUN add-apt-repository ppa:longsleep/golang-backports
RUN apt-get update
RUN apt-get install --no-install-recommends -y golang-1.11-go && rm -rf /var/lib/apt/lists/*;

# build the library
WORKDIR /go/src/github.com/appsflyer/kafka-mirror-tester
COPY *.go ./
COPY lib lib
COPY vendor vendor

RUN GOPATH=/go GOOS=linux /usr/lib/go-1.11/bin/go build -a -o main .

EXPOSE 8000

ENTRYPOINT ["./main"]
