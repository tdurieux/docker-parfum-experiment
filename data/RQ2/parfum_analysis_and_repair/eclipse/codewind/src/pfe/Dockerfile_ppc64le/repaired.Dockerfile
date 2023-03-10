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
#FROM centos as codewind-pfe-base

#FROM centos@sha256:f94c1d992c193b3dc09e297ffd54d8a4f1dc946c37cbeceb26d35ce1647f88d9 as codewind-pfe-base
#FROM centos@sha256:b5e66c4651870a1ad435cd75922fe2cb943c9e973a9673822d1414824a1d0475 as codewind-pfe-base
FROM centos:8.1.1911 AS codewind-pfe-base

LABEL org.opencontainers.image.title="Codewind-PFE" org.opencontainers.image.description="Codewind PFE" \
      org.opencontainers.image.url="https://codewind.dev/" \
      org.opencontainers.image.source="https://github.com/eclipse/codewind"

#ARG BUILDAH_RPM=https://cbs.centos.org/kojifiles/packages/buildah/1.11.4/4.el7/x86_64/buildah-1.11.4-4.el7.x86_64.rpm
#ARG SLIRP=https://cbs.centos.org/kojifiles/packages/slirp4netns/0.3.0/2.git4992082.el7/x86_64/slirp4netns-0.3.0-2.git4992082.el7.x86_64.rpm
ARG SLIRP=https://rpmfind.net/linux/opensuse/ports/ppc/distribution/leap/15.2/repo/oss/ppc64le/slirp4netns-0.4.5-lp152.1.2.ppc64le.rpm
#ARG LIBSEC=https://cbs.centos.org/kojifiles/packages/libseccomp/2.4.1/0.el7/x86_64/libseccomp-2.4.1-0.el7.x86_64.rpm

# Download the buildah RPM
#RUN curl -f -o buildah.rpm $BUILDAH_RPM
RUN curl -f -o slirp4netns.rpm $SLIRP
#RUN curl -f -o libseccomp.rpm $LIBSEC

# Download and set up Node 10.x RPM
#RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -

RUN yum install -y epel-release \
    && yum -y --enablerepo=epel install zip unzip python2 sudo ca-certificates openssl  wget gcc-c++ make slirp4netns.rpm && rm -rf /var/cache/yum


RUN wget https://nodejs.org/download/release/v13.13.0/node-v13.13.0-linux-ppc64le.tar.gz \
    && tar xvzf  node-v13.13.0-linux-ppc64le.tar.gz && rm node-v13.13.0-linux-ppc64le.tar.gz
ENV PATH=/node-v13.13.0-linux-ppc64le/bin:$PATH

RUN yum install -y  --enablerepo=epel libseccomp buildah \
    && yum clean all \
    && rm -rf /var/cache/yum

# Install docker client only
RUN cd /tmp \
    && curl -f -O https://download.docker.com/linux/static/stable/ppc64le/docker-18.06.3-ce.tgz \
    && echo '8fee410bc25628fa5310b33af1b362edcfe39533294a8325f3ed2cefac97c005  docker-18.06.3-ce.tgz' | sha256sum -c - \
    && tar -xvf docker-18.06.3-ce.tgz docker/docker \
    && cp /tmp/docker/docker /usr/bin/docker \
    && rm -rf /tmp/docker /tmp/docker-18.06.3-ce.tgz \
    && chown root:root /usr/bin/docker

#    && curl -O https://download.docker.com/linux/static/stable/x86_64/docker-18.09.6.tgz \
#    && echo '1f3f6774117765279fce64ee7f76abbb5f260264548cf80631d68fb2d795bb09  docker-18.09.6.tgz' | sha256sum -c - \
#    && tar -xvf docker-18.09.6.tgz docker/docker \
#    && cp /tmp/docker/docker /usr/bin/docker \
#    && rm -rf /tmp/docker /tmp/docker-18.09.6.tgz \
#    && chown root:root /usr/bin/docker

# Download OpenJ9 JRE, fixed to jre8u212-b04_openj9-0.14.2 version
RUN cd /tmp \
    && curl -f -sL -O https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u222-b10_openj9-0.15.1/OpenJDK8U-jre_ppc64le_linux_openj9_8u222b10_openj9-0.15.1.tar.gz \
    && echo 'c6c3faacc9830129f3356569d075b1e3d1c9ff097ee95b77256246e30e64c149  OpenJDK8U-jre_ppc64le_linux_openj9_8u222b10_openj9-0.15.1.tar.gz' | sha256sum -c - \
    && tar -xvf OpenJDK8U-jre_ppc64le_linux_openj9_8u222b10_openj9-0.15.1.tar.gz \
    && OPENJ9_JRE=$(find *jre | head -n 1) \
    && mkdir -p /opt/java \
    && cp -r /tmp/$OPENJ9_JRE /opt/java/jre \
    && rm -rf /tmp/$OPENJ9_JRE /tmp/OpenJDK8U-jre_ppc64le_linux_openj9_8u222b10_openj9-0.15.1.tar.gz

#    && curl -sL -O https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u222-b10_openj9-0.15.1/OpenJDK8U-jre_x64_linux_openj9_8u222b10_openj9-0.15.1.tar.gz \
#    && echo 'ae56994a7c8e8c19939c0c2ff8fe5a850eb2f23845c499aa5ede26deb3d5ad28  OpenJDK8U-jre_x64_linux_openj9_8u222b10_openj9-0.15.1.tar.gz' | sha256sum -c - \
#    && tar -xvf OpenJDK8U-jre_x64_linux_openj9_8u222b10_openj9-0.15.1.tar.gz \
#    && OPENJ9_JRE=$(find *jre | head -n 1) \
#    && mkdir -p /opt/java \
#    && cp -r /tmp/$OPENJ9_JRE /opt/java/jre \
#    && rm -rf /tmp/$OPENJ9_JRE /tmp/OpenJDK8U-jre_x64_linux_openj9_8u222b10_openj9-0.15.1.tar.gz

# Set up PFE container environment variables
ENV JAVA_HOME=/opt/java/jre \
    PATH=/opt/java/jre/bin:$PATH \
    HELM_HOME=/root/.helm

# Install the latest version of yq
RUN LATEST_RELEASE=$( curl -f -L -s -H 'Accept: application/json' https://github.com/mikefarah/yq/releases/latest) \
    && LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/') \
    && curl -f -sL -O https://github.com/mikefarah/yq/releases/download/$LATEST_VERSION/yq_linux_ppc64le \
    && mv ./yq_linux_ppc64le /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# Install kubectl
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/ppc64le/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

#RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
#    && chmod +x ./kubectl \
#    && mv ./kubectl /usr/local/bin/kubectl

# Install helm, fixed to the 3.0.0 version
RUN cd /tmp \
    && curl -f -O https://get.helm.sh/helm-v2.9.1-linux-ppc64le.tar.gz \
    && echo '22671d0a5667c10c11fedf6901eadcbedd66bc0024cc6e8db3669df8feef230e  helm-v2.9.1-linux-ppc64le.tar.gz' | sha256sum -c - \
    && tar -xvf helm-v2.9.1-linux-ppc64le.tar.gz \
    && cp /tmp/linux-ppc64le/helm /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && rm -rf /tmp/linux-ppc64le /tmp/helm-v2.9.1-linux-ppc64le.tar.gz

#RUN cd /tmp \
#    && curl -O https://get.helm.sh/helm-v3.0.0-linux-amd64.tar.gz \
#    && echo '10e1fdcca263062b1d7b2cb93a924be1ef3dd6c381263d8151dd1a20a3d8c0dc  helm-v3.0.0-linux-amd64.tar.gz' | sha256sum -c - \
#    && tar -xvf helm-v3.0.0-linux-amd64.tar.gz \
#    && cp /tmp/linux-amd64/helm /usr/local/bin/helm \
#    && chmod +x /usr/local/bin/helm \
#    && rm -rf /tmp/linux-amd64 /tmp/helm-v3.0.0-linux-amd64.tar.gz

WORKDIR /
# Softlink to /codewind-workspace to /projects so paths
# match in che.
RUN mkdir -m 777 -p /codewind-workspace && mkdir -m 777 ~/.npm-global \
    && ln -s /codewind-workspace /projects


######### Extensions setup.
#RUN mkdir /extensions
COPY /extensions /extensions



######### File watcher setup.
RUN mkdir /file-watcher
WORKDIR /file-watcher

COPY /file-watcher/dockerfiles /file-watcher/dockerfiles
COPY /file-watcher/scripts /file-watcher/scripts
COPY /file-watcher/server /file-watcher/server

WORKDIR /file-watcher/server
ENV PATH=/node-v13.13.0-linux-ppc64le/bin:$PATH

# Install w/ dev dependencies and do linting first, then delete node_modules and reinstall using production flag
RUN npm config set prefix '~/.npm-global' &&  npm ci \
    && npm run build \
    && rm -rf node_modules \
    && npm ci --production \
    && mkdir /file-watcher/fwdata \
    && npm cache clean --force -f \
    && npm pack nodemon

# Copy translation files to the distribution directory
RUN cp -r src/utils/locales dist/utils/locales

######### Portal setup
# This is copied in a later build stage.
# Changes outside /portal will be lost.
FROM codewind-pfe-base as codewind-pfe-portal

#RUN mkdir /portal
COPY /portal /portal

#WORKDIR /portal
#COPY /portal/package.json /portal/package-lock.json /portal/
#COPY /portal/sudoers /etc/sudoers

#COPY /portal/npm-start.sh /portal/nodemon.json /portal/
#COPY /portal/eslint-rules /portal/eslint-rules
#RUN chmod -R +rx /portal/npm-start.sh

#COPY /portal/.env /portal/.env
#COPY /portal/server.js /portal/
#COPY /portal/modules /portal/modules
#COPY /portal/routes /portal/routes
#COPY /portal/controllers /portal/controllers
#COPY /portal/config /portal/config
#COPY /portal/middleware /portal/middleware
#COPY /portal/docs /portal/docs

FROM codewind-pfe-base

# Don't force a file-watcher rebuild on a portal change.
# (Improves development builds significantly.)
COPY --from=codewind-pfe-portal /portal /portal
WORKDIR /portal

ENV PATH=/node-v13.13.0-linux-ppc64le/bin:$PATH

ARG NODE_ENV=production

RUN NODE_ENV=${NODE_ENV} npm ci \
    && npm cache clean --force -f

# Do the idc copy at the end since IDC is rebuilt as part of the build process and will cause the docker cache at this step to change
# and trigger all steps after this one to be executed instead of using the docker image cache. All steps after this one should be short
# to save time on local builds.
COPY /file-watcher/idc /file-watcher/idc
#RUN chmod -R +rx /file-watcher/idc


# Move the license files to the root directory
# to satisfy requirement from legal
# and chmod files which need to be executable
RUN mv /portal/LICENSE /portal/NOTICE.md / \
    && chmod -R +rx /portal/npm-start.sh \
    && chmod -R +rx /file-watcher/idc

EXPOSE 9090

# Moved the FORCE_COLOR env var for colored logs from root-watcher.sh to the Dockerfile
#ENV FORCE_COLOR=1
ARG IMAGE_BUILD_TIME
ARG ENABLE_CODE_COVERAGE=false
ENV NODE_ENV=${NODE_ENV} \
    IMAGE_BUILD_TIME=${IMAGE_BUILD_TIME} \
    ENABLE_CODE_COVERAGE=${ENABLE_CODE_COVERAGE} \
    FORCE_COLOR=1 \
    LOG_LEVEL=info


# TODO, work out how to start everything.
WORKDIR /
CMD [ "sh", "-c", " /file-watcher/scripts/root-watcher.sh ${HOST_WORKSPACE_DIRECTORY} ${CONTAINER_WORKSPACE_DIRECTORY} ; cd /portal ; npm start ;" ]
