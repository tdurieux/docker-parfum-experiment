ARG protocol

FROM us.icr.io/dia-registry/devops/build:latest as build

WORKDIR $GOPATH/src/
COPY cmd/farmingpools .

RUN go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/farmingpools /bin/farmingpools
COPY --from=build /config/ /config/

CMD ["farmingpools"]