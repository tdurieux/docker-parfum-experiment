FROM quay.io/openshift/origin-operator-registry:4.2.0

COPY manifests manifests

# Bundle should include only manifests related to the CSV,
# drop all additional files.
RUN find manifests/cluster-network-addons/*/ -type f ! -name '*.crd.*' ! -name '*.clusterserviceversion.*' -exec rm -f {} \;

# Initialize the database
RUN initializer --manifests manifests --output bundles.db

# There are multiple binaries in the origin-operator-registry
# We want the registry-server
ENTRYPOINT ["registry-server"]
CMD ["--database", "bundles.db"]