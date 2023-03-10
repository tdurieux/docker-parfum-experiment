FROM alpine:3.11
LABEL maintainer="sig-platform@spinnaker.io"
RUN apk --no-cache add --update bash openjdk11-jre
RUN addgroup -S -g 10111 spinnaker
RUN adduser -S -G spinnaker -u 10111 spinnaker
COPY keel-web/build/install/keel /opt/keel
RUN mkdir -p /opt/keel/plugins && chown -R spinnaker:nogroup /opt/keel/plugins
USER spinnaker
CMD ["/opt/keel/bin/keel"]