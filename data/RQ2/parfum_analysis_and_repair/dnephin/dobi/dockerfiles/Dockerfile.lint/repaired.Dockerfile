FROM    golang:1.14-alpine

RUN apk add --no-cache -U python3 py-pip python3-dev musl-dev gcc git bash
RUN pip install --no-cache-dir --ignore-installed pre-commit

COPY    --from=golangci/golangci-lint:v1.24.0 /usr/bin/golangci-lint /usr/bin/golangci-lint

WORKDIR /go/src/github.com/dnephin/dobi
COPY    .pre-commit-config.yaml ./
RUN     git init && pre-commit install-hooks

ENV     CGO_ENABLED=0
CMD     ["pre-commit", "run", "-a", "-v"]
