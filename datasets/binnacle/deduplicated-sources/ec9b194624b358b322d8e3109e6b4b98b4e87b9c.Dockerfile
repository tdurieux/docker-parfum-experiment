ARG GPU_SUFFIX=''
ARG FROM_VERSION
ARG FROM_IMAGE=harbor.h2o.ai/opsh2oai/h2o-3/dev-jdk-others-base
FROM ${FROM_IMAGE}${GPU_SUFFIX}:${FROM_VERSION}

ARG INSTALL_JAVA_VERSION
ENV JAVA_VERSION=${INSTALL_JAVA_VERSION}
COPY scripts/install_java_version scripts/java-${JAVA_VERSION}-vars.sh scripts/java-${JAVA_VERSION}-vars.sh scripts/install_java_version_local jdk-10.0.2_linux-x64_bin.tar.gz jdk1.8.0_171.zip /tmp/
RUN \
    chmod +x /tmp/install_java_version /tmp/java-${JAVA_VERSION}-vars.sh && \
    sync && \
    if [ "${JAVA_VERSION}" = '8' ] || [ "${JAVA_VERSION}" = '10' ]; then \
        /tmp/install_java_version_local ${JAVA_VERSION} /tmp/java-${JAVA_VERSION}-vars.sh; \
    else \
        /tmp/install_java_version ${JAVA_VERSION} /tmp/java-${JAVA_VERSION}-vars.sh; \
    fi && \
    rm /tmp/install_java_version \
        /tmp/install_java_version_local \
        /tmp/java-${JAVA_VERSION}-vars.sh \
        /tmp/jdk-10.0.2_linux-x64_bin.tar.gz \
        /tmp/jdk1.8.0_171.zip && \
    chmod a+w /usr/lib/jvm/

ENV \
  JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-oracle \
  PATH=/usr/lib/jvm/java-${JAVA_VERSION}-oracle/bin:${PATH}
