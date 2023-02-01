FROM golang AS builder

WORKDIR /go/src/github.com/relab/hotstuff

# speed up the build by downloading the modules first
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN go install ./...

FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y openssh-client && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /go/bin/* /usr/bin/

WORKDIR /root
ADD scripts/id .ssh/
ADD scripts/id.pub .ssh/
ADD scripts/ssh_config .ssh/config
ADD scripts/example_config.toml ./example_config.toml
