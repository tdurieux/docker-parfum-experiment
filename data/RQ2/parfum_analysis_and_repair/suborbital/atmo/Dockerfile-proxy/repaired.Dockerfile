FROM golang:1.17 as builder

RUN mkdir -p /go/src/github.com/suborbital/atmo
WORKDIR /go/src/github.com/suborbital/atmo/

# Deps first
COPY go.mod go.sum ./
RUN go mod download

# Then the rest
COPY . ./
RUN go mod vendor

RUN go install -tags proxy

FROM debian:buster-slim

RUN groupadd -g 999 atmo && \
    useradd -r -u 999 -g atmo atmo && \
	mkdir -p /home/atmo && \
	chown -R atmo /home/atmo && \
	chmod -R 700 /home/atmo

RUN apt-get update \
	&& apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

# atmo binary
COPY --from=builder /go/bin/atmo /usr/local/bin/atmo-proxy

WORKDIR /home/atmo

USER atmo