# Same as deploy/Dockerfile except it turns on KVM_EMULATION for CI
FROM quay.io/openshift/origin-operator-registry:latest

COPY deploy/olm-catalog /registry

USER root
# enable KVM_EMULATION for CI, needed by kubevirt-node-labeller on AWS
RUN find /registry/community-kubevirt-hyperconverged/ -type f -exec sed -E -i 's|^(\s*)- name: KVM_EMULATION$|\1- name: KVM_EMULATION\n\1  value: "true"|' {} \; || :

# Initialize the database
RUN initializer --manifests /registry/community-kubevirt-hyperconverged --output bundles.db

# There are multiple binaries in the origin-operator-registry
# We want the registry-server