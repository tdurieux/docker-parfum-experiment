FROM golang:1.9.4 as build

RUN curl -sL https://github.com/alexellis/license-check/releases/download/0.2.2/license-check \
      > /usr/bin/license-check \
      && chmod +x /usr/bin/license-check

WORKDIR /go/src/github.com/dailyhome/daily-home/gateway


COPY vendor         vendor
COPY server.go      .

# Run a gofmt and exclude all vendored code.
RUN test -z "$(gofmt -l $(find . -type f -name '*.go' -not -path "./vendor/*"))" \
    && go test $(go list ./... | grep -v integration | grep -v /vendor/ | grep -v /template/) -cover \
    && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o gateway .

FROM alpine:3.7

RUN addgroup -S app \
    && adduser -S -g app app

WORKDIR /home/app

EXPOSE 8080
ENV http_proxy      ""
ENV https_proxy     ""

COPY --from=build /go/src/github.com/dailyhome/daily-home/gateway/gateway    .
COPY assets     assets

RUN chown -R app:app ./

USER app

CMD ["./gateway"]
