FROM ubuntu:bionic
LABEL maintainer="sig-platform@spinnaker.io"
RUN apt-get update && apt-get -y --no-install-recommends install openjdk-11-jre-headless wget && rm -rf /var/lib/apt/lists/*;
RUN adduser --system --uid 10111 --group spinnaker
COPY echo-web/build/install/echo /opt/echo
RUN mkdir -p /opt/echo/plugins && chown -R spinnaker:nogroup /opt/echo/plugins
USER spinnaker
CMD ["/opt/echo/bin/echo"]
