# Builder and tester container for production build
FROM adoptopenjdk/openjdk11-openj9:alpine-slim as builder

RUN mkdir -p /develop
WORKDIR /develop

ARG SERVICE_DIR=.
COPY ${SERVICE_DIR} ./
RUN ./gradlew build

FROM adoptopenjdk/openjdk11-openj9:alpine-jre
LABEL version=${BUILD_VERSION} \
      company=sandbox \
      project=sandbox-jukka6 \
      role=server
RUN mkdir -p /service
WORKDIR /service
COPY --from=builder /build/libs/*.jar server.jar
RUN addgroup -S micronaut && \
    adduser -S -D -G micronaut micronaut

ARG BUILD_VERSION
ENV BUILD_VERSION ${BUILD_VERSION}
USER micronaut
EXPOSE 8080
# TODO: how to use secrets file in application.yml. just replace?