FROM ubuntu:bionic
LABEL maintainer="sig-platform@spinnaker.io"
RUN apt-get update && apt-get -y --no-install-recommends install openjdk-11-jre-headless wget && rm -rf /var/lib/apt/lists/*;
RUN adduser --system --uid 10111 --group spinnaker
COPY front50-web/build/install/front50 /opt/front50
RUN mkdir -p /opt/front50/plugins && chown -R spinnaker:nogroup /opt/front50/plugins
USER spinnaker
CMD ["/opt/front50/bin/front50"]
