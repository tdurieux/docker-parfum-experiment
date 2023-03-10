FROM registry.access.redhat.com/ubi8/ubi-minimal:latest AS stage

COPY . /ocs-operator

WORKDIR /ocs-operator

RUN microdnf install -y jq
RUN hack/generate-master-appregistry.sh


FROM quay.io/openshift/origin-operator-registry:latest

COPY --from=stage /ocs-operator/build/_output/appregistry/olm-catalog /registry/ocs-catalog

# Initialize the database
RUN initializer --manifests /registry/ocs-catalog --output bundles.db

# There are multiple binaries in the origin-operator-registry
# We want the registry-server
ENTRYPOINT ["registry-server"]
CMD ["--database", "bundles.db"]