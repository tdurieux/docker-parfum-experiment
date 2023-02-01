ARG GPU_SUFFIX=''
ARG FROM_VERSION
FROM harbor.h2o.ai/opsh2oai/h2o-3/dev-r-base${GPU_SUFFIX}:${FROM_VERSION}

ARG R_VERSION
ENV R_VERSION=${R_VERSION}

COPY scripts/install_R_version /tmp/
RUN \
    chmod +x /tmp/install_R_version && \
    sync && \
    /tmp/install_R_version ${R_VERSION} && \
    rm /tmp/install_R_version && \
    activate_R_${R_VERSION}

ENV PATH /usr/local/R/current/bin/:${PATH}
