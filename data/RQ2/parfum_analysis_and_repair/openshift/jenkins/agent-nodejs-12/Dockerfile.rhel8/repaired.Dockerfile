FROM registry.ci.openshift.org/ocp/4.11:jenkins-agent-base

MAINTAINER OpenShift Developer Services <openshift-dev-services+jenkins@redhat.com>

# Labels consumed by Red Hat build service
LABEL com.redhat.component="jenkins-agent-nodejs-12-rhel7-container" \
      name="openshift4/jenkins-agent-nodejs-12-rhel7" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Agent Nodejs" \
      io.k8s.description="The jenkins agent nodejs image has the nodejs tools on top of the jenkins slave base image." \
      io.openshift.tags="openshift,jenkins,agent,nodejs" \
      maintainer="openshift-dev-services+jenkins@redhat.com"

ENV NODEJS_VERSION=12 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

COPY contrib/bin/configure-agent /usr/local/bin/configure-agent

# Install NodeJS
RUN INSTALL_PKGS="nodejs nodejs-nodemon make gcc-c++" && \
    yum module enable -y nodejs:${NODEJS_VERSION} && \
    yum install -y --setopt=tsflags=nodocs --disableplugin=subscription-manager $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && rm -rf /var/cache/yum

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001
