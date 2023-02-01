#
# Copyright 2015 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive
ENV MAVEN_VERSION 3.2.2
ENV GRADLE_VERSION 2.3
# Set an environment variable to configure which container server to use.
# We use the Google Container Registry:
#     https://cloud.google.com/tools/container-registry/.
ENV GCLOUD_CONTAINER_SERVER gcr.io
# Eagerly run this authorization script upon startup.
ENV ONRUN $ONRUN "/google/scripts/gcloud_docker_auth.sh"

# Install common packages
RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y -qq --no-install-recommends \
      apparmor \
      apt-transport-https \
      ca-certificates-java \
      cron \
      curl \
      rsyslog \
      emacs-nox \
      gcc \
      git \
      initramfs-tools \
      iptables \
      jq \
      less \
      locales \
      lxc \
      make \
      man-db \
      manpages \
      mercurial \
      mysql-client \
      nano \
      nginx \
      openjdk-7-jre-headless \
      openssh-server \
      python \
      python3 \
      python-dev \
      python-setuptools \
      sudo \
      supervisor \
      symlinks \
      unzip \
      vim \
      wget \
      zip && \
  apt-get clean && \
  easy_install -U pip && pip install -U crcmod

# Install a UTF-8 locale by default.
RUN echo "en_US.UTF-8 UTF-8" >/etc/locale.gen && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8

# Install Docker.
RUN echo deb https://get.docker.io/ubuntu docker main \
        > /etc/apt/sources.list.d/docker.list
RUN apt-key adv \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        lxc-docker-1.9.1 && \
    apt-get clean

# Add jpetazzo's magic wrapper.
# This has been modified to start docker using 'service',
# which means setting DOCKER_DAEMON_ARGS does nothing.
# Instead, you can set DOCKER_SETTINGS_FILE to change
# /etc/default/docker prior to starting the docker service.
ADD third_party/jpetazzo/dind/wrapdocker /google/scripts/wrapdocker.sh
RUN chmod +x /google/scripts/wrapdocker.sh

# Must be excluded from aufs.
VOLUME /var/lib/docker

# Make the docker daemon log to a file, so we can realistically use the shell.
ENV LOG file

ENV DOCKER_HOST unix:///var/run/docker.sock

# Add our onrun utility, which allows commands to be run on startup
# by adding them to the ONRUN environment variable. For example:
#     ENV ONRUN $ONRUN "echo running my command"
ADD onrun.sh /google/scripts/onrun.sh
RUN chmod +x /google/scripts/onrun.sh

# Now run the wrapdocker script on startup.
ENV ONRUN $ONRUN "/google/scripts/wrapdocker.sh"

# Configure sshd to be used for Devshell connections.
RUN rm -fv /etc/ssh/ssh_host_*
RUN mkdir /var/run/sshd
ADD sshd_config /etc/ssh/

# Add devshell startup logic.
ADD devshell/startup.sh         /google/devshell/startup.sh
ADD devshell/authorized_keys.sh /google/devshell/authorized_keys.sh
ADD devshell/bashrc.google      /google/devshell/bashrc.google
RUN chmod -R 644 /google/devshell/bashrc.google
RUN mkdir /google/devshell/bashrc.google.d
ENV ONRUN $ONRUN "/google/devshell/startup.sh"

# Git credential helpers for source.developers.google.com and Gerrit.
ADD gitconfig /etc/gitconfig
RUN chmod -R 644 /etc/gitconfig

# Make it so the user does not need to type in their password for sudo
RUN echo "%sudo ALL=NOPASSWD: ALL" >> /etc/sudoers

# Start the cron daemon.
ENV ONRUN $ONRUN "cron"

# Add cron job to run "gcloud preview docker --authorize_only" every 5 minutes.
ADD gcloud_docker_auth.sh /google/scripts/gcloud_docker_auth.sh
RUN chmod +x /google/scripts/gcloud_docker_auth.sh
RUN (crontab -l 2>/dev/null; \
        echo '*/5 * * * * /google/scripts/gcloud_docker_auth.sh') \
    | crontab

# Install the Google Cloud SDK.
RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && \
    unzip google-cloud-sdk.zip -d /google/ && \
    rm google-cloud-sdk.zip
ENV CLOUD_SDK /google/google-cloud-sdk
RUN $CLOUD_SDK/install.sh \
        --usage-reporting=true \
        --rc-path=/etc/bash.bashrc \
        --bash-completion=true \
        --path-update=true \
        --disable-installation-options
ENV PATH $CLOUD_SDK/bin:$PATH

# Install the gcloud preview app support and Managed VMs.
RUN yes | \
    gcloud components update \
        core \
        gcloud

# Install the Java 7 JDK.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-7-jdk && \
    apt-get clean

# Install Maven $MAVEN_VERSION
RUN wget http://archive.apache.org/dist/maven/binaries/apache-maven-$MAVEN_VERSION-bin.zip && \
    unzip apache-maven-$MAVEN_VERSION-bin.zip && \
    rm apache-maven-$MAVEN_VERSION-bin.zip
ENV PATH /apache-maven-$MAVEN_VERSION/bin:$PATH

# Install Gradle $GRADLE_VERSION
RUN wget http://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
    unzip gradle-$GRADLE_VERSION-bin.zip && \
    rm gradle-$GRADLE_VERSION-bin.zip
ENV PATH /gradle-$GRADLE_VERSION/bin:$PATH

ENTRYPOINT ["/bin/bash", "/google/scripts/onrun.sh"]
