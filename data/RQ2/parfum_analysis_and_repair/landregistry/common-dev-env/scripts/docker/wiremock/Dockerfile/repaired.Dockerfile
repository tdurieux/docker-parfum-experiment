FROM openjdk:11-jre-slim

ARG WM_VERSION=2.32.0

RUN apt-get update && apt-get -y --no-install-recommends install curl && mkdir -p /wiremock/mappings && cd /wiremock && \
  curl -f -sSL -o wiremock.jar https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-jre8-standalone/$WM_VERSION/wiremock-jre8-standalone-$WM_VERSION.jar && rm -rf /var/lib/apt/lists/*;

WORKDIR /wiremock

# To ensure our fragments we copy in are actually persisted in between container recreates.
VOLUME /wiremock/mappings

CMD ["java","-jar","wiremock.jar", "--global-response-templating"]
