FROM us.icr.io/dia-registry/devops/build:latest as build

WORKDIR $GOPATH/src/

COPY ./cmd/services/indexCalculationService ./
RUN go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/indexCalculationService /bin/indexCalculationService
COPY --from=build /config/ /config/

ENTRYPOINT ["indexCalculationService"]