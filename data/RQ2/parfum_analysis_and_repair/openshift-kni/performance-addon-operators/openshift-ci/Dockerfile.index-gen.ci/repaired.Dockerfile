FROM quay.io/operator-framework/upstream-opm-builder

RUN opm index add \
--mode semver \
--bundles quay.io/openshift-kni/performance-addon-operator-bundle:4.11-snapshot \
--out-dockerfile index.Dockerfile \
--generate