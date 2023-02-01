FROM openjdk:17-alpine as build

WORKDIR /app
RUN apk add binutils # for objcopy, needed by jlink
RUN jlink --output jre --compress=2 --no-header-files --no-man-pages --strip-debug --add-modules \
    java.base,jdk.httpserver,java.sql,java.net.http,jdk.crypto.ec,java.naming,java.management,java.desktop,java.logging

FROM alpine as final
RUN adduser -S user
WORKDIR /app

COPY --from=build /app/jre /app/jre
COPY build/libs /app

# Run under non-privileged user with minimal write permissions
USER user

ENV JAVA_OPTS="-XX:MaxRAMPercentage=80"
CMD jre/bin/java $JAVA_OPTS -jar *.jar

# Heroku redefines exposed port
ENV PORT=8080
EXPOSE $PORT
