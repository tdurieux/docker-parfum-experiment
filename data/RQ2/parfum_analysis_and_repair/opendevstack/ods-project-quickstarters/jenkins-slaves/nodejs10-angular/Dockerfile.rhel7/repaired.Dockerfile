FROM cd/jenkins-slave-base

MAINTAINER Richard Attermeyer <richard.attermeyer@opitz-consulting.com>

# Labels consumed by Red Hat build service
LABEL com.redhat.component="jenkins-slave-nodejs-rhel7-docker" \
      name="openshift3/jenkins-slave-nodejs-rhel7" \
      version="3.6" \
      architecture="x86_64" \
      release="4" \
      io.k8s.display-name="Jenkins Slave Nodejs" \
      io.k8s.description="The jenkins slave nodejs image has the nodejs tools on top of the jenkins slave base image." \
      io.openshift.tags="openshift,jenkins,slave,nodejs"

ENV NODEJS_VERSION=8.11 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

# install google-chrome (for angular)
RUN yum-config-manager --enable rhel-7-server-extras-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    yum makecache

ADD https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm /root/google-chrome-stable_current_x86_64.rpm
RUN yum -y install redhat-lsb libXScrnSaver && rm -rf /var/cache/yum
RUN yum -y install /root/google-chrome-stable_current_x86_64.rpm && \
    ln -s /usr/lib64/libOSMesa.so.8 /opt/google/chrome/libosmesa.so && \
    yum clean all && \
    dbus-uuidgen > /etc/machine-id && rm -rf /var/cache/yum


# Install cypress dependencies
# Please note: xorg-x11-server-Xvfb is not available on RHEL via yum anymore, so "RUN yum install -y xorg-x11-server-Xvfb" won't work.
#   Therefore this Dockerfile uses the version from CentOS instead.
ADD http://mirror.centos.org/centos/7.7.1908/os/x86_64/Packages/xorg-x11-server-Xvfb-1.20.4-7.el7.x86_64.rpm /root/xorg-x11-server-Xvfb.x86_64.rpm
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

RUN curl -f --silent --location https://rpm.nodesource.com/setup_10.x | bash - && \
    yum install -y nodejs && \
    yum install -y gcc-c++ make && \
    curl -f --silent --location https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo && \
    yum install -y yarn && \
    yum clean all -y && rm -rf /var/cache/yum

COPY npmrc $HOME/.npm-global/etc/npmrc

RUN sed -i "s|NEXUS_HOST|$NEXUS_HOST|g" $HOME/.npm-global/etc/npmrc && \
    sed -i "s|NEXUS_AUTH|$(echo -n $NEXUS_AUTH | base64)|g" $HOME/.npm-global/etc/npmrc && \
    npm config set ca=null && \
    npm config set strict-ssl=false && \
    npm install -g @angular/cli@8.0.1 --unsafe-perm=true --allow-root && \
    npm install -g cypress@3.3.1 --unsafe-perm=true --allow-root > /dev/null && \
    npm --version && \
    ng version && \
    cypress verify && npm cache clean --force;


RUN chgrp -R 0 $HOME && \
    chmod -R g=u $HOME
USER 1001
