FROM registry.access.redhat.com/ubi8/ubi-minimal:latest AS stage

COPY . /ocs-operator

WORKDIR /ocs-operator

RUN hack/generate-appregistry.sh


FROM quay.io/openshift/origin-operator-registry:latest

COPY --from=stage /ocs-operator/build/_output/appregistry/olm-catalog /registry/ocs-catalog

# replaces ocs-operator image with the one built by openshift ci
RUN find /registry/ocs-catalog/ -type f -exec sed -i "s|image\: .*/ocs-operator:.*$|image: default-route-openshift-image-registry.apps.build02.ci.devcluster.openshift.com/${OPENSHIFT_BUILD_NAMESPACE}/stable:ocs-operator|g" {} \; || :

# Initialize the database
RUN initializer --manifests /registry/ocs-catalog --output bundles.db

# There are multiple binaries in the origin-operator-registry
# We want the registry-server
ENTRYPOINT ["registry-server"]
CMD ["--database", "bundles.db"]