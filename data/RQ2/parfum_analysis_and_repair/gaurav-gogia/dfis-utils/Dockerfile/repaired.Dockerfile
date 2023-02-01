FROM golang:latest

WORKDIR /go/src/dfis-utils
COPY . .

RUN apt-get update && apt-get install --no-install-recommends -y libpcap-dev && rm -rf /var/lib/apt/lists/*;

CMD go build -o dfis-utils .
