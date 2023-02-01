FROM ubuntu:bionic
LABEL maintainer="sig-platform@spinnaker.io"
RUN apt-get update && apt-get -y --no-install-recommends install openjdk-11-jre-headless wget && rm -rf /var/lib/apt/lists/*;
RUN adduser --system --uid 10111 --group spinnaker
COPY fiat-web/build/install/fiat /opt/fiat
RUN mkdir -p /opt/fiat/plugins && chown -R spinnaker:nogroup /opt/fiat/plugins
USER spinnaker
CMD ["/opt/fiat/bin/fiat"]
