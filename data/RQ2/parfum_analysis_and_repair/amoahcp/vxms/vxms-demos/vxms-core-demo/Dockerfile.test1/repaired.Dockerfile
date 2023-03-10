# GraalVM docker image used for AoT compilation
FROM maven:3.5.4-jdk-11 AS mavenbuilder
ADD . /app
WORKDIR /app
RUN mvn clean install


FROM panga/graalvm-ce:latest AS build-aot
WORKDIR /app
COPY --from=mavenbuilder /app/ /app
# Build image
RUN native-image \
    --no-server \
    -Djava.net.preferIPv4Stack=true \
     -Dio.netty.noUnsafe=true \
    -Dvertx.disableDnsResolver=true \
    -H:+ReportUnsupportedElementsAtRuntime \
    -H:ReflectionConfigurationFiles=./reflectconfigs/netty.json \
    -jar "target/vxms-core-demo-fat.jar"

# Create new image from alpine
FROM frolvlad/alpine-glibc:alpine-3.8
RUN apk add --no-cache ca-certificates
# Copy generated native executable from build-aot
COPY --from=build-aot /app/vxms-core-demo-fat /vxms-core-demo-fat
# Set the entrypoint