FROM golang:1.18-alpine as builder

RUN mkdir -p /go/src/build

WORKDIR /go/src/build

COPY app/go.mod .
COPY app/go.sum .
RUN go mod download

ADD app /go/src/build/

ARG SKAFFOLD_GO_GCFLAGS
RUN CGO_ENABLED=0 go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -o dataplane-worker workers/worker.go


FROM python:3.9.12-slim-bullseye

# RUN apk update && apk add --no-cache tzdata make automake gcc g++ subversion python3-dev
# RUN rm -rf /var/cache/apk/*

# Create appuser
ENV USER=appuser
ENV UID=10001

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/dataplane" \
    --shell "/sbin/nologin" \
#    --no-create-home \
    --uid "${UID}" \
    "${USER}"


COPY --from=builder go/src/build/dataplane-worker /dataplane/dataplane-worker

RUN chmod +x /dataplane/dataplane-worker

RUN mkdir /dataplane/code-files/ && chown -R appuser:appuser /dataplane
RUN chmod +w /dataplane/code-files/

WORKDIR /dataplane

USER appuser:appuser

CMD ["./dataplane-worker"]