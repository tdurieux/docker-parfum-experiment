FROM golang As build-go

# For generating certificates
RUN git clone https://github.com/cloudflare/cfssl/ /go/src/github.com/cloudflare/cfssl && \
    cd /go/src/github.com/cloudflare/cfssl/ && \
    make && \
    mv bin/* /usr/local/bin/

ADD . /go/src/github.com/fristonio/xene
WORKDIR /go/src/github.com/fristonio/xene

# Build and generate certificates for xene.
RUN make build && \
    make -C contrib/certs/ certs

# For the second stage for the agent image use docker dind image
FROM docker:dind

RUN apk add --no-cache bash git curl

WORKDIR /etc/xene/certs/
COPY --from=build-go /go/src/github.com/fristonio/xene/contrib/certs/ /etc/xene/certs/
COPY --from=build-go /go/bin/* /usr/local/bin/
ADD contrib/docker/xene-agent-entrypoint.sh /usr/local/bin/xene-agent-entrypoint.sh

RUN chmod +x /usr/local/bin/xene-agent-entrypoint.sh

WORKDIR /
EXPOSE 6061

ENTRYPOINT ["xene-agent-entrypoint.sh"]