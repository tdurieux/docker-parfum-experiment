FROM openjdk:8u212-jre-alpine3.9
MAINTAINER Maksim Kostromin https://github.com/daggerok
RUN apk --no-cache add busybox-suid bash curl \
 && addgroup app-group \
 && adduser -h /home/app -s /bin/bash -D -u 1025 app app-group
USER app
WORKDIR /home/app
VOLUME ["/home/app"]
ARG java_opts=" -Djava.net.preferIPv4Stack=true "
ENV JAVA_OPTS=${java_opts}
ENTRYPOINT java ${JAVA_OPTS} -jar ./app.jar
EXPOSE 8080
HEALTHCHECK --timeout=1s --retries=35 CMD curl -f http://127.0.0.1:8080/config || exit 1
COPY ./target/*.jar ./app.jar
