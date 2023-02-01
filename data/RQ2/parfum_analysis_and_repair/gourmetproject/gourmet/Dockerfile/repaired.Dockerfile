# Usage
# docker run -it --rm \
#  -v $PWD/example_configs/minimal.yml:/etc/gourmet.yml \
#  gourmet/gourmet -c /etc/gourmet.yml

FROM golang:1.13

WORKDIR /go/github.com/gourmetproject/gourmet

RUN apt-get update && apt-get -y --no-install-recommends install libpcap-dev && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN GO111MODULE=on make build

ENTRYPOINT ["./bin/gourmet"]
