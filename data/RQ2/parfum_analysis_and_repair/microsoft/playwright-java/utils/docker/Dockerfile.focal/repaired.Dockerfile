FROM ubuntu:focal

ARG DOCKER_IMAGE_NAME_TEMPLATE="mcr.microsoft.com/playwright/java:v%version%-focal"

# === INSTALL JDK and Maven ===

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-11-jdk maven \
    # Install utilities required for downloading browsers
    curl \
    # Install utilities required for downloading driver
    unzip && \
    rm -rf /var/lib/apt/lists/* && \
    # Create the pwuser
    adduser pwuser

ARG PW_TARGET_ARCH
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-${PW_TARGET_ARCH}

# === BAKE BROWSERS INTO IMAGE ===

# Browsers will remain downloaded in `/ms-playwright`.
# Note: make sure to set 777 to the registry so that any user can access
# registry.

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

RUN mkdir /ms-playwright && \
    mkdir /tmp/pw-java

COPY . /tmp/pw-java

RUN cd /tmp/pw-java && \
    ./scripts/download_driver_for_all_platforms.sh && \
    mvn install -D skipTests --no-transfer-progress && \
    DEBIAN_FRONTEND=noninteractive mvn exec:java -e -D exec.mainClass=com.microsoft.playwright.CLI \
                     -D exec.args="install-deps" -f playwright/pom.xml --no-transfer-progress && \
    mvn exec:java -e -D exec.mainClass=com.microsoft.playwright.CLI \
                     -D exec.args="install" -f playwright/pom.xml --no-transfer-progress && \
    mvn exec:java -e -D exec.mainClass=com.microsoft.playwright.CLI \
                     -D exec.args="mark-docker-image '${DOCKER_IMAGE_NAME_TEMPLATE}'" -f playwright/pom.xml --no-transfer-progress && \
    rm -rf /tmp/pw-java && \
    chmod -R 777 $PLAYWRIGHT_BROWSERS_PATH