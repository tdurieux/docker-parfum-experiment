# build phase
FROM alpine:3.9 as build
LABEL stage=build

RUN apk --update add --no-cache \
  &&   apk add --no-cache ca-certificates openssl curl wget \
  &&   update-ca-certificates \
  &&   rm -rf /var/lib/apt/lists/* \
  &&   rm -f /var/cache/apk/*

ARG UPSTREAM_VERSION
ARG MIRROR

ENV PROJECT_BASE_DIR /opt/nifi-registry
ENV PROJECT_HOME ${PROJECT_BASE_DIR}/nifi-registry-${UPSTREAM_VERSION}

ENV UPSTREAM_BINARY_URL nifi/nifi-registry/nifi-registry-${UPSTREAM_VERSION}/nifi-registry-${UPSTREAM_VERSION}-bin.tar.gz
ENV DOCKERIZE_VERSION v0.6.1

# Download, validate, and expand Apache NiFi-Registry binary.
RUN mkdir -p ${PROJECT_BASE_DIR} \
    && curl -fSL ${MIRROR}/${UPSTREAM_BINARY_URL} -o ${PROJECT_BASE_DIR}/nifi-registry-${UPSTREAM_VERSION}-bin.tar.gz \
    && echo "$(curl ${MIRROR}/${UPSTREAM_BINARY_URL}.sha256) *${PROJECT_BASE_DIR}/nifi-registry-${UPSTREAM_VERSION}-bin.tar.gz" | sha256sum -c - \
    && tar -xvzf ${PROJECT_BASE_DIR}/nifi-registry-${UPSTREAM_VERSION}-bin.tar.gz -C ${PROJECT_BASE_DIR} \
    && rm ${PROJECT_BASE_DIR}/nifi-registry-${UPSTREAM_VERSION}-bin.tar.gz \
    && rm -fr ${PROJECT_HOME}/docs

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# base phase
FROM openjdk:8-jdk-alpine as base

RUN apk --update add --no-cache ca-certificates bash git less openssh sshpass \
  && update-ca-certificates \
  &&   rm -rf /var/lib/apt/lists/* \
  &&   rm -f /var/cache/apk/*

ARG BUILD_RFC3339
ARG COMMIT
ARG VERSION

LABEL \
      org.opencontainers.image.ref.name="michalklempa/nifi-registry" \
      org.opencontainers.image.title="Unofficial Docker Image For NiFi Registry" \
      org.opencontainers.image.created=$BUILD_RFC3339 \
      org.opencontainers.image.authors="Michal Klempa <michal.klempa@gmail.com>" \
      org.opencontainers.image.documentation="https://github.com/michalklempa/docker-nifi-registry/blob/master/README.md" \
      org.opencontainers.image.description="michalklempa/nifi-registry docker image is an alternative and unofficial image for NiFi Registry project" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.source="https://github.com/michalklempa/docker-nifi-registry/" \
      org.opencontainers.image.revision=$COMMIT \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.url="https://hub.docker.com/r/michalklempa/nifi-registry" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.docker.cmd='docker run -p 18080:18080 --name nifi-registry -d michalklempa/nifi-registry:latest' \
      org.label-schema.docker.cmd.devel='docker run -p 8000:8000 -p 18080:18080 -e''BOOTSTRAP_JAVA_ARG_DEBUG=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8000'' --name nifi-registry -d michalklempa/nifi-registry:latest'

ARG UPSTREAM_VERSION

ENV PROJECT_BASE_DIR /opt/nifi-registry
ENV PROJECT_HOME ${PROJECT_BASE_DIR}/nifi-registry-${UPSTREAM_VERSION}

ENV PROJECT_TEMPLATE_DIR ${PROJECT_BASE_DIR}/templates

ENV PROJECT_CONF_DIR ${PROJECT_HOME}/conf

# Setup NiFi-Registry user
RUN mkdir -p ${PROJECT_BASE_DIR}

COPY --from=build ${PROJECT_HOME} ${PROJECT_HOME}
COPY --from=build /usr/local/bin/dockerize /usr/local/bin/dockerize
COPY ./templates ${PROJECT_TEMPLATE_DIR}

COPY sh/ ${PROJECT_BASE_DIR}/scripts/

RUN mkdir -p ${PROJECT_HOME}/docs

# Web HTTP(s) ports
EXPOSE 18080 18443

WORKDIR ${PROJECT_HOME}

FROM base as plain

# Apply configuration and start NiFi Registry
CMD ${PROJECT_BASE_DIR}/scripts/start-plain.sh

FROM plain as plainuser
ARG UID=1000
ARG GID=1000

RUN addgroup -g ${GID} nifi \
    && adduser -s /bin/bash -u ${UID} -G nifi -D nifi \
    && chown -R nifi:nifi ${PROJECT_BASE_DIR}
USER nifi

FROM base as default

ENV FLOW_PROVIDER file
ENV FLOW_PROVIDER_GIT_FLOW_STORAGE_DIRECTORY $PROJECT_BASE_DIR/flow-storage
ENV FLOW_PROVIDER_FILE_FLOW_STORAGE_DIRECTORY $PROJECT_BASE_DIR/flow-storage

ENV EXTENSION_BUNDLE_PROVIDER file
ENV EXTENSION_BUNDLE_PROVIDER_FILE_EXTENSION_BUNDLE_STORAGE_DIRECTORY $PROJECT_BASE_DIR/extension-bundle-storage

# Apply configuration and start NiFi Registry
CMD ${PROJECT_BASE_DIR}/scripts/start.sh

FROM default as defaultuser
ARG UID=1000
ARG GID=1000

RUN addgroup -g ${GID} nifi \
    && adduser -s /bin/bash -u ${UID} -G nifi -D nifi \
    && chown -R nifi:nifi ${PROJECT_BASE_DIR}
USER nifi

