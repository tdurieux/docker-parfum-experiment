ARG BASE_BRANCH
ARG SOURCE=/go/src/github.com/submariner-io/submariner-operator

FROM quay.io/submariner/shipyard-dapper-base:${BASE_BRANCH} AS shipyard
ARG SOURCE

COPY . ${SOURCE}

RUN make -C ${SOURCE} LOCAL_BUILD=1 packagemanifests

FROM quay.io/operator-framework/upstream-registry-builder as builder
ARG SOURCE

COPY --from=shipyard ${SOURCE}/packagemanifests manifests
RUN  find manifests -name \*.clusterserviceversion.yaml -exec sed -i 's/replaces: submariner.v0.0.0//g' {} + && \
     /bin/initializer -o ./bundles.db

FROM scratch
COPY --from=builder /etc/nsswitch.conf /etc/nsswitch.conf
COPY --from=builder /bundles.db /bundles.db
COPY --from=builder /bin/registry-server /registry-server
COPY --from=builder /bin/grpc_health_probe /bin/grpc_health_probe
EXPOSE 50051
ENTRYPOINT ["/registry-server"]
CMD ["--database", "bundles.db"]