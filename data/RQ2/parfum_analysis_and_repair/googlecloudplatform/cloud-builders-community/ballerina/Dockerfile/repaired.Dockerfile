FROM debian

LABEL maintainer="mail@hirantha.xyz"

ARG ballerina_version=1.2.4

RUN apt-get update \
    && apt-get install --no-install-recommends -y git wget openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;

RUN wget https://dist.ballerina.io/downloads/${ballerina_version}/ballerina-linux-installer-x64-${ballerina_version}.deb \
    && dpkg -i ballerina-linux-installer-x64-${ballerina_version}.deb \
    && ballerina -v

ENTRYPOINT [ "ballerina" ]