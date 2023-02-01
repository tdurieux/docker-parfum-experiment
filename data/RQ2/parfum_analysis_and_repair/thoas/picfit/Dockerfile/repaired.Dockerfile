FROM golang:1.16-buster as builder
LABEL stage=builder

ENV REPO=thoas/picfit

ADD . /go/src/github.com/${REPO}

WORKDIR /go/src/github.com/${REPO}

RUN make docker-build-static && mv bin/picfit /picfit

###

FROM debian:buster-slim

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /picfit /picfit

CMD ["/picfit"]
