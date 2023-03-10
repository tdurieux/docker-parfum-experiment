FROM golang:1.17.6-alpine3.15 AS os

RUN apk -U add --no-cache ca-certificates git make gcc g++ bash && update-ca-certificates
RUN go get github.com/client9/misspell/cmd/misspell && \
    go get github.com/fzipp/gocyclo && \
    go get golang.org/x/lint/golint && \
    go get github.com/securego/gosec/cmd/gosec && \
    go get github.com/google/addlicense && \
    go get github.com/github/hub

RUN apk add --no-cache curl
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin

# codefresh/venona-tester