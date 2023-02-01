FROM ubuntu:bionic
LABEL maintainer="sig-platform@spinnaker.io"
RUN apt-get update && apt-get -y --no-install-recommends install openjdk-11-jre-headless wget && rm -rf /var/lib/apt/lists/*;
RUN adduser --system --uid 10111 --group spinnaker
COPY orca-web/build/install/orca /opt/orca
RUN mkdir -p /opt/orca/plugins && chown -R spinnaker:nogroup /opt/orca/plugins
USER spinnaker
CMD ["/opt/orca/bin/orca"]
