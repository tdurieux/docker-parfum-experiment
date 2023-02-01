FROM maven:3.8.5-openjdk-18 AS api-builder

WORKDIR /opt/openex-build/openex
COPY openex-model ./openex-model
COPY openex-framework ./openex-framework
COPY openex-api ./openex-api
COPY openex-injectors ./openex-injectors
COPY openex-front/build ./openex-front/build
COPY pom.xml ./pom.xml
RUN mvn install -DskipTests -Pdev

FROM openjdk:18-slim AS app

RUN ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split
RUN ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb
RUN ln -s /bin/rm /usr/sbin/rm
RUN ln -s /bin/tar /usr/sbin/tar
RUN DEBIAN_FRONTEND=noninteractive apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -qq -y tini; rm -rf /var/lib/apt/lists/*;
COPY --from=api-builder /opt/openex-build/openex/openex-api/target/openex-api.jar ./

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["java", "-jar", "openex-api.jar"]
