FROM golang:1.18

## To compile:
## cd Gokapi/build/
## docker build . --tag gokapi-builder
## docker run --rm -it -v ../:/usr/src/myapp -w /usr/src/myapp gokapi-builder

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y ca-certificates openssl zip && \
  update-ca-certificates && \
  rm -rf /var/lib/apt && rm -rf /var/lib/apt/lists/*;

COPY go.mod /tmp/tmp/go.mod

RUN cd /tmp/tmp/ && go mod download && rm -r /tmp/tmp

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
