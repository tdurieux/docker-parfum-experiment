# To build:
#   docker build --tag universa/node:latest --compress -f docker/node/Dockerfile .
#   docker push universa/node

#
# Multi-stage build
#

# Just build the Universa JAR files, leaving many temporary files behind.

FROM openjdk:11-jdk-slim-buster as build_universa
COPY /docker/node/gradle.properties /root/.gradle/gradle.properties
COPY / /code/
WORKDIR /code
RUN echo \
    && mkdir -p /usr/share/man/man1 \
    && apt-get update --quiet=2 --yes \
	&& apt-get install --quiet=2 --yes --no-install-recommends --fix-missing gradle \
	&& gradle -Dfile.encoding=utf-8 :universa_node:fatJar -x test \
	&& gradle -Dfile.encoding=utf-8 :uniclient:fatJar -x test \
	&& mkdir -p /deploy \
	&& mv /code/uniclient/build /deploy/build-client && mv /code/universa_node/build /deploy/build-node \
	&& apt-get clean --quiet=2 --yes && apt-get autoremove --quiet=2 --yes && rm -rf /var/lib/apt/lists/*

# Copy only the needed files.