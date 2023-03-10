FROM us.icr.io/dia-registry/devops/build:latest as build

WORKDIR $GOPATH/src/

COPY ./cmd/services/pairDiscoveryService ./
RUN go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/pairDiscoveryService /bin/pairDiscoveryService
COPY --from=build /config/ /config/

CMD ["pairDiscoveryService"]