####
# This Dockerfile is used in order to build a container that runs the Quarkus application in native (no JVM) mode.
# It uses a micro base image, tuned for Quarkus native executables.
# It reduces the size of the resulting container image.
# Check https://quarkus.io/guides/quarkus-runtime-base-image for further information about this image.
#
# Before building the container image run:
#
# ./mvnw package -Pnative
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.native-micro -t quarkus/quarkus-getting-started-vertx .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quarkus/quarkus-getting-started-vertx
#
###
FROM ghcr.io/graalvm/graalvm-ce:22 AS build-aot
LABEL maintainer="Sascha Möllering <smoell@amazon.de>"

RUN microdnf install -y unzip zip

RUN \
    curl -f -s "https://get.sdkman.io" | bash; \
    source "$HOME/.sdkman/bin/sdkman-init.sh"; \
    sdk install maven; \
    gu install native-image;

COPY ./pom.xml ./pom.xml
COPY src ./src/

ENV MAVEN_OPTS='-Xmx8g'

RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && mvn -Dmaven.test.skip=true clean package -Pnative

FROM quay.io/quarkus/quarkus-micro-image:1.0
WORKDIR /work/
RUN chown 1001 /work \
    && chmod "g+rwX" /work \
    && chown 1001:root /work
COPY --chown=1001:root --from=build-aot /app/target/*-runner /work/application

EXPOSE 8080
USER 1001

CMD ["./application", "-Dquarkus.http.host=0.0.0.0"]
