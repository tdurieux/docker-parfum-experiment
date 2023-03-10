FROM golang:1.14 AS go-builder

ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on

RUN mkdir /scratch-tmp

WORKDIR /ui
COPY ./go.mod ./go.sum ./
RUN go mod download
COPY ./api ./api
COPY ./internal ./internal
COPY ./cmd ./cmd
COPY ./e2e ./e2e

ARG VERSION=dev
RUN go test -ldflags "-s -w -X github.com/criticalstack/ui/internal/controller.Version=$VERSION" -c ./e2e/

FROM scratch AS final

LABEL MAINTAINER="Critical Stack <dev@criticalstack.com>"

COPY --from=go-builder /scratch-tmp /tmp
COPY --from=go-builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=go-builder /ui/e2e.test /
COPY --from=go-builder /ui/e2e/testdata /testdata

ENTRYPOINT ["/e2e.test", "-test.v", "-external", "-e2e"]