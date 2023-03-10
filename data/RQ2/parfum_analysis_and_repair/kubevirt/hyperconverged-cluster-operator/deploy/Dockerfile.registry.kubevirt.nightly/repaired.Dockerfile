FROM quay.io/openshift/origin-operator-registry:latest
ARG KUBEVIRT_PROVIDER
ARG HCO_VERSION
COPY --from=builder /go/src/github.com/kubevirt/hyperconverged-cluster-operator/deploy/olm-catalog /registry
USER root

# enable KVM_EMULATION for CI, needed by kubevirt-node-labeller on AWS
RUN find /registry/community-kubevirt-hyperconverged/ -type f -exec sed -E -i 's|^(\s*)- name: KVM_EMULATION$|\1- name: KVM_EMULATION\n\1  value: "true"|' {} \; || :

# TODO: openshift-ci is currently configured to use two different
# addresses for its internal registry depending from the OCP version:
# please adapt this value according to that.
# This is going to be solved only once we will move to openshift-ci generated
# index images also for the upgrade tests.
# OCP 4.5:
ARG CI_REGISTRY=registry.svc.ci.openshift.org
# OCP 4.6:
# ARG CI_REGISTRY=registry.build01.ci.openshift.org

RUN echo "HCO_VERSION: ${HCO_VERSION}"
RUN if [ -n "$KUBEVIRT_PROVIDER" ]; then \
      sed -r -i "s|quay.io/kubevirt/hyperconverged-cluster-operator(@sha256)?:.*$|registry:5000/kubevirt/hyperconverged-cluster-operator:latest|g" /registry/community-kubevirt-hyperconverged/${HCO_VERSION}/kubevirt-hyperconverged-operator.v${HCO_VERSION}.clusterserviceversion.yaml \
      sed -r -i "s|quay.io/kubevirt/hyperconverged-cluster-webhook(@sha256)?:.*$|registry:5000/kubevirt/hyperconverged-cluster-webhook:latest|g" /registry/community-kubevirt-hyperconverged/${HCO_VERSION}/kubevirt-hyperconverged-operator.v${HCO_VERSION}.clusterserviceversion.yaml \
    else \
      sed -i -r "s|quay.io/kubevirt/hyperconverged-cluster-operator(@sha256)?:.*$|${CI_REGISTRY}/${OPENSHIFT_BUILD_NAMESPACE}/stable:hyperconverged-cluster-operator|g" /registry/community-kubevirt-hyperconverged/${HCO_VERSION}/kubevirt-hyperconverged-operator.v${HCO_VERSION}.clusterserviceversion.yaml \
      sed -i -r "s|quay.io/kubevirt/hyperconverged-cluster-webhook(@sha256)?:.*$|${CI_REGISTRY}/${OPENSHIFT_BUILD_NAMESPACE}/stable:hyperconverged-cluster-webhook|g" /registry/community-kubevirt-hyperconverged/${HCO_VERSION}/kubevirt-hyperconverged-operator.v${HCO_VERSION}.clusterserviceversion.yaml \
    fi
RUN cat /registry/community-kubevirt-hyperconverged/kubevirt-hyperconverged.package.yaml

# Initialize the database
RUN initializer --manifests /registry/community-kubevirt-hyperconverged --output bundles.db

# There are multiple binaries in the origin-operator-registry
# We want the registry-server
ENTRYPOINT ["registry-server"]
CMD ["--database", "bundles.db"]