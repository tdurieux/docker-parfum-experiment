FROM golang:1.12

RUN cd /opt && curl -fsSL https://raw.githubusercontent.com/pact-foundation/pact-ruby-standalone/v1.66.0/install.sh | bash
ENV PATH="/opt/pact/bin:${PATH}"

WORKDIR /go/src/github.com/replicatedhq/replicated
