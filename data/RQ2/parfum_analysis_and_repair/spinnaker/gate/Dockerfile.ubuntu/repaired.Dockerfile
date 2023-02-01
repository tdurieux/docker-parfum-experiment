FROM ubuntu:bionic
LABEL maintainer="sig-platform@spinnaker.io"
RUN apt-get update && apt-get -y --no-install-recommends install openjdk-11-jre-headless wget && rm -rf /var/lib/apt/lists/*;
RUN adduser --system --uid 10111 --group spinnaker
COPY gate-web/build/install/gate /opt/gate
RUN mkdir -p /opt/gate/plugins && chown -R spinnaker:nogroup /opt/gate/plugins
USER spinnaker
CMD ["/opt/gate/bin/gate"]
