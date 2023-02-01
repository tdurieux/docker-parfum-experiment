FROM ubuntu:bionic
LABEL maintainer="sig-platform@spinnaker.io"
RUN apt-get update && apt-get -y --no-install-recommends install openjdk-11-jre-headless wget && rm -rf /var/lib/apt/lists/*;
RUN adduser --system --uid 10111 --group spinnaker
COPY kayenta-web/build/install/kayenta /opt/kayenta
RUN mkdir -p /opt/kayenta/plugins && chown -R spinnaker:nogroup /opt/kayenta/plugins
USER spinnaker
CMD ["/opt/kayenta/bin/kayenta"]
