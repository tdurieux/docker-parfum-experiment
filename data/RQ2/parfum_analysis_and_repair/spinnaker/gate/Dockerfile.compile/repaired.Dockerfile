FROM alpine:3.11
RUN apk add --no-cache --update \
    openjdk11 \
    && rm -rf /var/cache/apk
LABEL maintainer="sig-platform@spinnaker.io"
ENV GRADLE_USER_HOME /workspace/.gradle
ENV GRADLE_OPTS -Xmx4g
CMD ./gradlew --no-daemon gate-web:installDist -x test
