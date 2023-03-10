FROM golang:1.18.1 as builder

# Install required tools
RUN apt-get update -y && apt-get install --no-install-recommends -y upx && rm -rf /var/lib/apt/lists/*;

ADD . /project
WORKDIR /project

# Compile binaries
RUN make
RUN make pack

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /project/bin /bin
