ARG PIPELINES_BASE_VERSION

FROM docker.bintray.io/jfrog/pipelines-api:${PIPELINES_BASE_VERSION} AS base
FROM jfrog-docker-reg2.bintray.io/pipelines-node:1.4.2 AS base2

# The new image based on registry.access.redhat.com/ubi
FROM registry.access.redhat.com/ubi8

USER root

LABEL name="JFrog Pipelines K8s Node" \
      description="JFrog Pipelines K8s Node image based on the Red Hat Universal Base Image." \
      vendor="JFrog" \
      summary="JFrog Pipelines K8s Node (Red Hat UBI)" \
      com.jfrog.license_terms="https://jfrog.com/platform/enterprise-plus-eula/"

# Set vars
ENV DOCKER_VERSION=18.09.9
ENV NODE_VERSION=10.19.0

#RUN apt-get update && \
#    apt-get install sudo grep jq tar curl python-minimal wget ca-certificates rsync vim -y


RUN yum install -y --disableplugin=subscription-manager wget && \
    yum install -y --disableplugin=subscription-manager procps && \
    yum install -y --disableplugin=subscription-manager net-tools && \
    yum install -y --disableplugin=subscription-manager hostname && \
    yum install -y --disableplugin=subscription-manager https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y --disableplugin=subscription-manager sudo grep tar python36 ca-certificates rsync vim && rm -rf /var/cache/yum



RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
RUN cp /root/.nvm/versions/node/v${NODE_VERSION}/bin/node /usr/bin/
RUN cp /root/.nvm/versions/node/v${NODE_VERSION}/bin/npm /usr/bin/
RUN /root/.nvm/versions/node/v${NODE_VERSION}/bin/npm install leasot@latest -g

RUN curl -f -0 -L https://npmjs.com/install.sh | sh

# Get files needed to run Build Plane node
COPY --from=base /opt/jfrog/pipelines/app/api/bin/buildPlane-x86_64-RHEL_7.rpm /tmp/buildPlane-x86_64-RHEL_7.rpm
COPY ./executeAffinityGroup_fix.js /tmp

RUN yum localinstall -y --disableplugin=subscription-manager /tmp/buildPlane-x86_64-RHEL_7.rpm
RUN mkdir -p /tmp/var/opt/jfrog/pipelines/reqKick/execute/
RUN mkdir -p /jfrog-init
RUN cat /tmp/executeAffinityGroup_fix.js >> /tmp/var/opt/jfrog/pipelines/reqKick/execute/executeAffinityGroup.js
RUN sed -i '/function __restart(bag) {/,$d' /tmp/var/opt/jfrog/pipelines/reqKick/execute/executeAffinityGroup.js
RUN cp -fr /tmp/var/opt/jfrog/pipelines/ /jfrog-init
RUN rm -fr /tmp/var && rm -fr /tmp/*

COPY --from=base2 /jfrog-init /jfrog-init

# Install app dependencies
RUN cd /jfrog-init/reqKick; npm install && npm cache clean --force;

# Install docker client
RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz -P /tmp/docker && \
    tar -xzf /tmp/docker/docker-$DOCKER_VERSION.tgz --directory /opt && \
    ln -s /opt/docker/docker /usr/bin/docker && \
    rm -fr /tmp/docker && rm /tmp/docker/docker-$DOCKER_VERSION.tgz


# Install nodejs pm2 monitoring
RUN npm install pm2 -g && npm cache clean --force;


# Add EULA information to meet the Red Hat container image certification requirements
COPY entplus_EULA.txt /licenses/

# Environment needed for Pipelines
ENV JF_PIPELINES_USER=pipelines \
    PIPELINES_USER_ID=1000721117 \
    PIPELINES_VERSION=${PIPELINES_BASE_VERSION}

RUN mkdir -p /home/${JF_PIPELINES_USER}
RUN useradd -M -s /usr/sbin/nologin --uid ${PIPELINES_USER_ID} --user-group pipelines && \
    chown -R ${PIPELINES_USER_ID}:${PIPELINES_USER_ID} /jfrog-init /home/${JF_PIPELINES_USER}

USER ${JF_PIPELINES_USER}


WORKDIR /jfrog-init/reqKick
CMD ["pm2-runtime", "/jfrog-init/reqKick/reqKick.app.js"]