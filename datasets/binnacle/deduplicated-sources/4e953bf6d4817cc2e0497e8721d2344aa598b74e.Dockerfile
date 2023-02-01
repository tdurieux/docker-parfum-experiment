ARG GPU_SUFFIX=''
ARG FROM_VERSION
FROM harbor.h2o.ai/opsh2oai/h2o-3/dev-build-base${GPU_SUFFIX}:${FROM_VERSION}

USER jenkins
ARG H2O_BRANCH=master
RUN \
    BUILD_HADOOP=false /tmp/build-h2o-3
USER root
