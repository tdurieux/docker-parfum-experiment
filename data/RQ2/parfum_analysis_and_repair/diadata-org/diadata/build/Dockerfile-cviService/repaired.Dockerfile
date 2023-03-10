FROM us.icr.io/dia-registry/devops/build:latest as build

WORKDIR $GOPATH/src/

COPY ./cmd/services/cviService ./
RUN go install

FROM gcr.io/distroless/base
COPY --from=build /go/bin/cviService /bin/cviService
COPY --from=build /config/ /config/

CMD ["cviService"]