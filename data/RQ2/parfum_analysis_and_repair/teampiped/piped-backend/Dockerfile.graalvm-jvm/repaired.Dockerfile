FROM ghcr.io/graalvm/native-image:latest as build

WORKDIR /app/

COPY . /app/

RUN --mount=type=cache,target=/root/.gradle/caches/ \
    ./gradlew shadowJar

RUN jlink \
    --add-modules java.base,java.logging,java.sql,java.management,java.xml,java.naming,java.desktop,jdk.crypto.ec \
    --strip-debug \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output /javaruntime

FROM debian:stable-slim

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=build /javaruntime $JAVA_HOME

WORKDIR /app/

COPY --from=build /app/build/libs/piped-1.0-all.jar /app/piped.jar

COPY VERSION .

EXPOSE 8080

CMD java -jar /app/piped.jar