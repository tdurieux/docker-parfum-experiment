FROM quay.io/vrutkovs/cirrus-run
WORKDIR /go/src/github.com/openshift/okd-machine-os
COPY . .
# Build Dockerfile.cosa in Cirrus CI
RUN export OPENSHIFT_BUILD_REFERENCE=$(git rev-parse FETCH_HEAD) && \
    export FETCH_HEAD_CONTENT="$(cat ./.git/FETCH_HEAD)" && \
    export OPENSHIFT_BUILD_SOURCE="${FETCH_HEAD_CONTENT##* }" && \
    echo "Building ${OPENSHIFT_BUILD_REFERENCE} in ${OPENSHIFT_BUILD_SOURCE}" && \
    set -o pipefail && \
    cirrus-run --github vrutkovs/okd-os --branch main --show-build-log always | tee /tmp/build.log && \
    # replace resulting image in Dockerfile
    IMAGE=$(grep "Committing container" -A1 /tmp/build.log | tail -n1 | tr ' ' '\n' | head -n1) && \
    sed "s;INITIAL_IMAGE;${IMAGE};g" Dockerfile.template > /tmp/Dockerfile && \
    mkdir ./extensions