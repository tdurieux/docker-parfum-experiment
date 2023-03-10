FROM us.icr.io/dia-registry/devops/build:latest as build

WORKDIR $GOPATH/src/
COPY ./cmd/http/restServer ./
RUN go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/restServer /bin/restServer
COPY --from=build /config/ /config/

CMD ["restServer"]