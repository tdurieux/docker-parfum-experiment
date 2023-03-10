FROM quay.io/openshift/origin-cli:latest

ENV MUST_GATHER_ROOT=/opt/must-gather-root
ENV PATH=${MUST_GATHER_ROOT}/bin:${PATH} HOME=${MUST_GATHER_ROOT}

# Copy all collection scripts to /usr/bin
COPY collection-scripts ${MUST_GATHER_ROOT}/bin/
COPY configs ${MUST_GATHER_ROOT}/configs/
RUN mkdir ${MUST_GATHER_ROOT}/tar 
# Optional
#COPY templates /templates

# Change file permission
RUN chmod -R u+x ${MUST_GATHER_ROOT} && \
    chgrp -R 0 ${MUST_GATHER_ROOT} && \
    chmod -R g=u ${MUST_GATHER_ROOT} /etc/passwd

WORKDIR ${MUST_GATHER_ROOT}

USER 10001
ENTRYPOINT ${MUST_GATHER_ROOT}/gather