FROM opendevstackorg/ods-jenkins-agent-base-centos7:latest

# Labels consumed by Red Hat build service
LABEL com.redhat.component="jenkins-agent-nodejs-rhel7-docker" \
    name="openshift3/jenkins-agent-nodejs-rhel7" \
    version="3.6" \
    architecture="x86_64" \
    io.k8s.display-name="Jenkins agent Nodejs" \
    io.k8s.description="The jenkins agent nodejs image has the nodejs tools on top of the jenkins agent base image." \
    io.openshift.tags="openshift,jenkins,agent,nodejs"

ARG nexusUrl
ARG nexusAuth

ENV NODEJS_VERSION=16 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    CHROME_VERSION=99.0.4844.74

# install google-chrome (for angular)
RUN yum-config-manager --enable rhel-7-server-extras-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms

ADD https://dl.google.com/linux/chrome/rpm/stable/x86_64/google-chrome-stable-${CHROME_VERSION}-1.x86_64.rpm /root/google-chrome.rpm
RUN yum -y install redhat-lsb libXScrnSaver && rm -rf /var/cache/yum
RUN yum -y install /root/google-chrome.rpm && \
    ln -s /usr/lib64/libOSMesa.so.8 /opt/google/chrome/libosmesa.so && \
    yum clean all && \
    dbus-uuidgen > /etc/machine-id && \
    rm /root/google-chrome.rpm && rm -rf /var/cache/yum

# Install cypress dependencies
# Please note: xorg-x11-server-Xvfb is not available on RHEL via yum anymore, so "RUN yum install -y xorg-x11-server-Xvfb" won't work.
#   Therefore this Dockerfile uses the version from CentOS instead.
ADD http://mirror.centos.org/centos/7/os/x86_64/Packages/xorg-x11-server-Xvfb-1.20.4-10.el7.x86_64.rpm /root/xorg-x11-server-Xvfb.x86_64.rpm
RUN yum install -y /root/xorg-x11-server-Xvfb.x86_64.rpm && \
    yum install -y gtk2-2.24* && \
    yum install -y libXtst* && \
    yum install -y libXScrnSaver* && \
    yum install -y GConf2* && \
    yum install -y alsa-lib* && \
    yum install -y nss-devel libnotify-devel gnu-free-sans-fonts && \
    yum clean all -y && rm -rf /var/cache/yum
# libXScrnSaver* provides libXss
# GConf2* provides libgconf-2
# alsa-lib* provides libasound


# Install NodeJS + Yarn + Angular CLI
# installation details see: https://www.softwarecollections.org/en/
# and the base image relies on scl_enable
COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

# Install NodeJS
# https://github.com/nodesource/distributions#installation-instructions-1
RUN curl -f --silent --location https://rpm.nodesource.com/setup_${NODEJS_VERSION}.x | bash - && \
    yum install -y nodejs && \
    yum install -y gcc-c++ make && rm -rf /var/cache/yum

# Install Yarn
# https://classic.yarnpkg.com/en/docs/install/#centos-stable
RUN curl -f --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
    yum install -y yarn && \
    yum clean all -y && rm -rf /var/cache/yum

# Install Python 3 (because node-gyp, an ionic dependency, uses it) and set it as default
RUN yum install -y python3 py3-pip && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    python -V && rm -rf /var/cache/yum

RUN npm config set registry=$nexusUrl/repository/npmjs/ && \
    npm config set always-auth=true && \
    npm config set _auth=$(echo -n $nexusAuth | base64) && \
    npm config set email=no-reply@opendevstack.org && \
    npm config set ca=null && \
    npm config set strict-ssl=false && \
    yarn config set registry $nexusUrl/repository/npmjs/ -g && \
    npm --version && yarn cache clean;

RUN chgrp -R 0 $HOME && \
    chmod -R g=u $HOME
USER 1001
