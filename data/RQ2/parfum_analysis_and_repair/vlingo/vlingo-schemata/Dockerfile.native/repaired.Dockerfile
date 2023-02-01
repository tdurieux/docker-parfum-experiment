FROM ghcr.io/graalvm/graalvm-ce:ol8-java11-21.1.0 as build

LABEL maintainer="VLINGO XOOM Team <info@vlingo.io>"

ARG XOOM_HOME=/schemata

WORKDIR $XOOM_HOME
COPY target/xoom-schemata-*-jar-with-dependencies.jar ./xoom-schemata.jar
COPY target/classes/META-INF/ ./classes/META-INF/

RUN gu install native-image
RUN native-image -jar xoom-schemata.jar

FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3

ENV XOOM_ENV="env"
RUN microdnf install autoconf automake libtool make tar \
                 glibc-devel \
                 libgcc.i686 glibc-devel.i686
WORKDIR /work/
COPY --from=build /schemata/xoom-schemata /work/xoom-schemata

# set up permissions for farmer `1001`
RUN chmod 775 /work /work/xoom-schemata \
  && chown -R 1001 /work \
  && chmod -R "g+rwX" /work \
  && chown -R 1001:root /work

EXPOSE 9019
USER 1001

ENTRYPOINT ["./xoom-schemata", "-Xmx68m"]