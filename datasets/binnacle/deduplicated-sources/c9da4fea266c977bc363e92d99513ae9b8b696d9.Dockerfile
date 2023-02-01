ARG GPU_SUFFIX=''
ARG FROM_VERSION
ARG GRADLE_VERSION
FROM harbor.h2o.ai/opsh2oai/h2o-3/dev-build-gradle-${GRADLE_VERSION}${GPU_SUFFIX}:${FROM_VERSION}

USER jenkins
ARG H2O_BRANCH=master
RUN \
    BUILD_HADOOP=true /tmp/build-h2o-3
USER root
