#------------------------------------------------------------------------------
# All the tools required to build mysql-migrator, including execution
# of integration tests.
#
# Build from the basedir:
#   docker build -f docker/Dockerfile-build -t mysql-migrator-build docker
#
# Verify the content of the image by running a shell session in it:
#   docker run -it mysql-migrator-build bash
#
# CirrusCI builds the image when needed. No need to manually upload it
# to Google Cloud Container Registry. See section "gke_container" of .cirrus.yml
#------------------------------------------------------------------------------

FROM gradle:4.10.1-jdk8

USER root

# Avoiding JVM Delays Caused by Random Number Generation (https://docs.oracle.com/cd/E13209_01/wlcp/wlss30/configwlss/jvmrand.html)
RUN sed -i 's|securerandom.source=file:/dev/random|securerandom.source=file:/dev/urandom|g' $JAVA_HOME/jre/lib/security/java.security

RUN apt-get update && apt-get -y --no-install-recommends install xvfb && rm -rf /var/lib/apt/lists/*;

#==============================================================================
# Maven, for integration tests
#==============================================================================
ENV MAVEN_VERSION 3.5.3
ENV SHA b52956373fab1dd4277926507ab189fb797b3bc51a2a267a193c931fffad8408
ENV BASE_URL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

COPY docker/settings.xml /usr/share/maven/conf/settings.xml
RUN chown gradle:gradle /usr/share/maven/ref


# Back to the user of the base image
USER gradle
