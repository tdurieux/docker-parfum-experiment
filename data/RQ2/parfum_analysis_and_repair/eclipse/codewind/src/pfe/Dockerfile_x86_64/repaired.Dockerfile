#*******************************************************************************
# Copyright (c) 2019 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v2.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v20.html
#
# Contributors:
#     IBM Corporation - initial API and implementation
#*******************************************************************************
FROM centos:8.1.1911 AS codewind-pfe-base
RUN yum -y install nodejs \
    && yum -y update platform-python-pip-9.0.3-16.el8.noarch python3-libs-3.6.8-23.el8.x86_64 python3-dnf-4.2.17-6.el8.noarch python3-libcomps-0.1.11-4.el8.x86_64 python3-pip-wheel-9.0.3-16.el8.noarch \
    && yum clean all \
    && rm -rf /var/cache/yum

LABEL org.opencontainers.image.title="Codewind-PFE" org.opencontainers.image.description="Codewind PFE" \
    org.opencontainers.image.url="https://codewind.dev/" \
    org.opencontainers.image.source="https://github.com/eclipse/codewind"

ARG BUILDAH_RPM=https://cbs.centos.org/kojifiles/packages/buildah/1.11.4/4.el7/x86_64/buildah-1.11.4-4.el7.x86_64.rpm
ARG SLIRP=https://cbs.centos.org/kojifiles/packages/slirp4netns/0.3.0/2.git4992082.el7/x86_64/slirp4netns-0.3.0-2.git4992082.el7.x86_64.rpm
ARG LIBSEC=https://cbs.centos.org/kojifiles/packages/libseccomp/2.4.1/0.el7/x86_64/libseccomp-2.4.1-0.el7.x86_64.rpm

# Set up PFE container environment variables
ENV JAVA_HOME=/opt/java/jre \
    PATH=/opt/java/jre/bin:$PATH \
    HELM_HOME=/root/.helm

# Download the buildah RPM and associated ones, install and remove them
RUN curl -f -o buildah.rpm $BUILDAH_RPM \
    && curl -f -o slirp4netns.rpm $SLIRP \
    && curl -f -o libseccomp.rpm $LIBSEC \ 
    && yum -y install zip unzip ca-certificates openssl slirp4netns.rpm libseccomp.rpm buildah.rpm  \
    && yum clean all \
    && rm -rf /var/cache/yum /buildah.rpm /slirp4netns.rpm /libseccomp.rpm \
# Install docker client only
    && cd /tmp \
    && curl -f -O https://download.docker.com/linux/static/stable/x86_64/docker-18.09.6.tgz \
    && echo '1f3f6774117765279fce64ee7f76abbb5f260264548cf80631d68fb2d795bb09  docker-18.09.6.tgz' | sha256sum -c - \
    && tar -xvf docker-18.09.6.tgz docker/docker \
    && cp /tmp/docker/docker /usr/bin/docker \
    && rm -rf /tmp/docker /tmp/docker-18.09.6.tgz \
    && chown root:root /usr/bin/docker \
# Download OpenJ9 JRE, fixed to jre8u212-b04_openj9-0.14.2 version
    && cd /tmp \
    && curl -f -sL -O https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u222-b10_openj9-0.15.1/OpenJDK8U-jre_x64_linux_openj9_8u222b10_openj9-0.15.1.tar.gz \
    && echo 'ae56994a7c8e8c19939c0c2ff8fe5a850eb2f23845c499aa5ede26deb3d5ad28  OpenJDK8U-jre_x64_linux_openj9_8u222b10_openj9-0.15.1.tar.gz' | sha256sum -c - \
    && tar -xvf OpenJDK8U-jre_x64_linux_openj9_8u222b10_openj9-0.15.1.tar.gz \
    && OPENJ9_JRE=$(find *jre | head -n 1) \
    && mkdir -p /opt/java \
    && cp -r /tmp/$OPENJ9_JRE /opt/java/jre \
    && rm -rf /tmp/$OPENJ9_JRE /tmp/OpenJDK8U-jre_x64_linux_openj9_8u222b10_openj9-0.15.1.tar.gz \
# Install the latest version of yq
    && YQ_VERSION=2.4.1 \
    && curl -f -sL -O https://github.com/mikefarah/yq/releases/download/$YQ_VERSION/yq_linux_amd64 \
    && echo '754c6e6a7ef92b00ef73b8b0bb1d76d651e04d26aa6c6625e272201afa889f8b  yq_linux_amd64' | sha256sum -c - \
    && mv ./yq_linux_amd64 /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq \
# Install kubectl
    && curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl \
# Install helm, fixed to the 3.0.0 version
    && cd /tmp \
    && curl -f -O https://get.helm.sh/helm-v3.0.0-linux-amd64.tar.gz \
    && echo '10e1fdcca263062b1d7b2cb93a924be1ef3dd6c381263d8151dd1a20a3d8c0dc  helm-v3.0.0-linux-amd64.tar.gz' | sha256sum -c - \
    && tar -xvf helm-v3.0.0-linux-amd64.tar.gz \
    && cp /tmp/linux-amd64/helm /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && rm -rf /tmp/linux-amd64 /tmp/helm-v3.0.0-linux-amd64.tar.gz \
# Softlink to /codewind-workspace to /projects so paths
# match in che.
    && mkdir -m 777 -p /codewind-workspace \
    && ln -s /codewind-workspace /projects

######### Extensions setup.
COPY /extensions /extensions

######### File watcher setup.
COPY /file-watcher/dockerfiles /file-watcher/dockerfiles
COPY /file-watcher/scripts /file-watcher/scripts
COPY /file-watcher/server /file-watcher/server

WORKDIR /file-watcher/server

# Install w/ dev dependencies and do linting first, then delete node_modules and reinstall using production flag
RUN npm ci \
    && npm run build \
    && rm -rf node_modules \
    && npm ci --production \
    && mkdir /file-watcher/fwdata \
    && npm cache clean --force -f \
    && npm pack nodemon \
    && cp -r src/utils/locales dist/utils/locales

######### Portal setup
# This is copied in a later build stage.
# Changes outside /portal will be lost.
FROM codewind-pfe-base as codewind-pfe-portal

COPY /portal /portal

FROM codewind-pfe-base

# Don't force a file-watcher rebuild on a portal change.
# (Improves development builds significantly.)
COPY --from=codewind-pfe-portal /portal /portal
WORKDIR /portal

ARG NODE_ENV=production

RUN NODE_ENV=${NODE_ENV} npm ci \
    && npm cache clean --force -f

# Do the idc copy at the end since IDC is rebuilt as part of the build process and will cause the docker cache at this step to change
# and trigger all steps after this one to be executed instead of using the docker image cache. All steps after this one should be short
# to save time on local builds.
COPY /file-watcher/idc /file-watcher/idc
COPY /profiling-parser/target/profiling-parser.jar /portal/scripts/
COPY /profiling-parser/monitoring-api.jar /portal/scripts/

# Move the license files to the root directory
# to satisfy requirement from legal
# and chmod files which need to be executable
RUN mv /portal/LICENSE /portal/NOTICE.md / \
    && chmod -R +rx /portal/npm-start.sh \
    && chmod -R +rx /file-watcher/idc

EXPOSE 9090

ARG IMAGE_BUILD_TIME
ARG ENABLE_CODE_COVERAGE=false
ENV NODE_ENV=${NODE_ENV} \
    IMAGE_BUILD_TIME=${IMAGE_BUILD_TIME} \
    ENABLE_CODE_COVERAGE=${ENABLE_CODE_COVERAGE} \
    FORCE_COLOR=1 \
    LOG_LEVEL=info

WORKDIR /
CMD [ "sh", "-c", " /file-watcher/scripts/root-watcher.sh ${HOST_WORKSPACE_DIRECTORY} ${CONTAINER_WORKSPACE_DIRECTORY} ; cd /portal ; npm start ;" ]
