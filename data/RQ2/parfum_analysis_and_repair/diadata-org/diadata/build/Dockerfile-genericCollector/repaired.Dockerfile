ARG exchange

FROM us.icr.io/dia-registry/devops/build:latest as build

WORKDIR $GOPATH/src/

COPY ./cmd/exchange-scrapers/collector ./
RUN go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/collector /bin/collector
COPY --from=build /config/ /config/

CMD ["collector"]