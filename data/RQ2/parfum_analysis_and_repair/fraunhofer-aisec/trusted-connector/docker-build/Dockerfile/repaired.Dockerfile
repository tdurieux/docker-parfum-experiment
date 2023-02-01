ARG BASE_IMAGE=eclipse-temurin:17-jdk-focal
FROM $BASE_IMAGE

LABEL AUTHOR="Michael Lux (michael.lux@aisec.fraunhofer.de)"

# Install tools for nodejs/yarn setup and protobuf compiler
RUN apt-get update -qq && apt-get install -y --no-install-recommends -qq bash sudo rsync protobuf-compiler && rm -rf /var/lib/apt/lists/*;

COPY run.sh .
RUN chmod +x run.sh
VOLUME /build

ENTRYPOINT ["/run.sh"]
CMD ["yarnBuild", "check", ":ids-connector:build", "--parallel"]