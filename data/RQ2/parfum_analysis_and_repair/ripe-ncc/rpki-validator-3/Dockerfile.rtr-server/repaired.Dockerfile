#
# Two step Dockerfile
#   - first build step: check hash and unpack archive
#   - second build step: install dependencies, move files around, adjust config
#
# Unpacking in a separate build step makes sure the archive that is COPY-d does
# not become a layer in the final image.
#
FROM library/openjdk:11-jre-slim as intermediate

ARG RTRSERVER_GENERIC_BUILD_ARCHIVE

COPY ${RTRSERVER_GENERIC_BUILD_ARCHIVE} /tmp/

RUN mkdir -p /opt/rtr-server \
    && tar -zxf /tmp/$(basename $RTRSERVER_GENERIC_BUILD_ARCHIVE) -C /opt/rtr-server/ --strip-components=1

# Second build step: Move files into place
FROM library/openjdk:11-jre-slim
# Keep the file name and sha256 in the metadata
ARG RTRSERVER_GENERIC_BUILD_ARCHIVE
LABEL validation.archive.file="$(basename ${RTRSERVER_GENERIC_BUILD_ARCHIVE})"

# Webserver on 8081
EXPOSE 8081
# RTR protocol on 8323
EXPOSE 8323

# Used by `rpki-rtr-server.sh`
ENV CONFIG_DIR="/config"
ENV RPKI_VALIDATOR_VALIDATED_OBJECTS_URI="https://rpki-validator.ripe.net/api/objects/validated"

COPY --from=intermediate /opt/rtr-server /opt/rtr-server
WORKDIR /opt/rtr-server

# S6 init-like system for proper <C-c>
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && rm /tmp/s6-overlay-amd64.tar.gz

# UseContainerSupport: important
RUN sed -i '/MEM_OPTIONS=/c\MEM_OPTIONS="-Xms$JVM_XMS -Xmx$JVM_XMX -XX:+ExitOnOutOfMemoryError -XX:+UseContainerSupport"' /opt/rtr-server/rpki-rtr-server.sh  \
    # Move about config and set defaults (creates /config)
    && mv /opt/rtr-server/conf /config \
    # Listen to 0.0.0.0 instead of just localhost
    && sed -i 's/server.address=localhost/server.address=0.0.0.0/g' ${CONFIG_DIR}/application.properties \
    && sed -i 's/rtr.server.address=localhost/rtr.server.address=0.0.0.0/g' ${CONFIG_DIR}/application.properties \
    && useradd -M -d /opt/rtr-server rpki

# https://github.com/just-containers/s6-overlay functionality
RUN echo "/config true rpki,32768:32768 0666 0777\n" > /etc/fix-attrs.d/01-rtr-server

# rtr-server process in container runs as daemon user
ENTRYPOINT ["/init"]
CMD s6-setuidgid rpki /opt/rtr-server/rpki-rtr-server.sh
# Volumes are initialized with the files in them from container build time
VOLUME /config
