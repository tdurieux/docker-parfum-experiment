# Base Distro Arg
ARG OPENJDK8_ALPINE_VERSION

FROM openjdk:$OPENJDK8_ALPINE_VERSION

# Build Args
ARG APKTOOL_DOWNLOAD_URL

# Content
WORKDIR /apktool
ADD $APKTOOL_DOWNLOAD_URL apktool.jar
ENTRYPOINT [ "java", "-jar", "apktool.jar" ]