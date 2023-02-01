# This Dockerfile allows you to build Datasafe CLI using GraalVM (for Linux)
FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends curl -y && apt-get install --no-install-recommends libz-dev gcc -y && rm -rf /var/lib/apt/lists/*;

ENV GRAVIS="https://raw.githubusercontent.com/DanySK/Gravis-CI/master/"
ENV JDK="graalvm@19.2.0"
# Needed for Jabba
ENV TRAVIS_OS_NAME=linux

RUN curl -f "${GRAVIS}.install-jdk-travis.sh" --output ~/.install-jdk-travis.sh
RUN chmod +x ~/.install-jdk-travis.sh
RUN ~/.install-jdk-travis.sh

RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/adorsys/datasafe
WORKDIR datasafe

RUN .travis/install_custom_jdk_and_add_security_providers.sh

# 1. Build classes, because there can be problems with SSL afterwards
# Make JAVA_HOME avaiable as docker executes RUN commands independently
# https://forums.docker.com/t/set-environment-variable-through-dockerfile/28421/2
RUN . ~/.jdk_config && ./mvnw clean install -B -V -DskipTests
# 2. Change security providers of JDK, after that java may face problems with SSL
RUN . ~/.jdk_config && chmod +x .travis/enable_bouncycastle_security.sh && .travis/enable_bouncycastle_security.sh
# 3. Build native image, no settings.xml needed
RUN . ~/.jdk_config && ./mvnw -f datasafe-cli/pom.xml clean package -B -V -Pnative-image -DskipTests

WORKDIR datasafe-cli/target

# Use datasafe-cli
RUN echo 'echo "To use newly built DATASAFE-CLI - just run ./datasafe-cli"' >> /etc/bash.bashrc
CMD bash