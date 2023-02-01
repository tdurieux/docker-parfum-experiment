FROM ubuntu:bionic
LABEL maintainer="sig-platform@spinnaker.io"
RUN apt-get update && apt-get -y --no-install-recommends install openjdk-11-jre-headless wget && rm -rf /var/lib/apt/lists/*;
RUN adduser --system --uid 10111 --group spinnaker
COPY keel-web/build/install/keel /opt/keel
RUN mkdir -p /opt/keel/plugins && chown -R spinnaker:nogroup /opt/keel/plugins
USER spinnaker
CMD ["/opt/keel/bin/keel"]
