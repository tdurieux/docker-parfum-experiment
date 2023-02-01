ARG GPU_SUFFIX=''
ARG FROM_VERSION
FROM harbor.h2o.ai/opsh2oai/h2o-3/dev-python-base${GPU_SUFFIX}:${FROM_VERSION}

COPY scripts/install_python_version /tmp

ARG H2O_BRANCH=master
ARG PYTHON_VERSION
ENV PYTHON_VERSION=${PYTHON_VERSION}

RUN \
    /tmp/install_python_version ${PYTHON_VERSION}
