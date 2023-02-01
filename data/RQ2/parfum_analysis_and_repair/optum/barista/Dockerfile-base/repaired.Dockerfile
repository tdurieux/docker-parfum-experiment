# This is a docker file that forms the basis of the three images built
# for Barista.  Much of the functionality is common, so the three images
# will inherit this dockerfile in order to reduce build time and reduce errors.
ARG REPO=""
ARG TAG="12.16.1"
FROM ${REPO}node:${TAG}
LABEL maintainer=randy.olinger@optum.com

# Create app directory
WORKDIR /usr/src/app
ENV HOME=/usr/src/app

RUN rm -fr barista-scan barista-web barista-api  doc


RUN mkdir -p -v -m 770 .config /.config /.cache/yarn  && chown root:root /.cache /.cache/yarn /.config .config\
    && chmod -R g+rw . && chmod -R g+rwx .config /.config

#Install JAVA
RUN apt-get update && apt install --no-install-recommends -y openjdk-8-jre-headless && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

#Install Yarn
RUN rm /usr/local/bin/yarnpkg
RUN rm /usr/local/bin/yarn
RUN npm config ls -l && npm install -g  yarn yarnrc && npm cache clean --force;

#Build this image with docker build -f Dockerfile-base -t barista-base:$(date +%Y%m%d%H%M) .
