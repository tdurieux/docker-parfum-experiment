FROM us.icr.io/dia-registry/devops/build:latest as build

WORKDIR $GOPATH/src/

COPY ./cmd/assetCollectionService ./
RUN go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/assetCollectionService /bin/assetCollectionService
COPY --from=build /config/ /config/

CMD ["assetCollectionService"]