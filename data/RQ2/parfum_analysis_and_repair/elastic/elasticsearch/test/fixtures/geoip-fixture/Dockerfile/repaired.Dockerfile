FROM ubuntu:20.04

RUN apt-get update -qqy && apt-get install --no-install-recommends -qqy openjdk-17-jre-headless && rm -rf /var/lib/apt/lists/*;

ARG fixtureClass
ARG port

ENV GEOIP_FIXTURE_CLASS=${fixtureClass}
ENV GEOIP_FIXTURE_PORT=${port}

ENTRYPOINT exec java -classpath "/fixture/shared/*:/fixture/shared/providers" \
    $GEOIP_FIXTURE_CLASS 0.0.0.0 "$GEOIP_FIXTURE_PORT"

EXPOSE $port
