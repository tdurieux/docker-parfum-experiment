# Create a Docker image that is ready to run the Randoop tests,
# using JDK 8.

FROM centos
MAINTAINER Michael Ernst <mernst@cs.washington.edu>

# According to
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/:
#  * Put "apt-get update" and "apt-get install" in the same RUN command.
#  * Do not run "apt-get upgrade"; instead get upstream to update.
# CentOS 8 will use dnf instead of yum.

RUN yum -q -y upgrade \
&& yum -q -y install \
  java-1.8.0-openjdk \
  java-1.8.0-openjdk-devel && rm -rf /var/cache/yum

RUN yum -q -y upgrade \
&& yum -q -y install \
  findutils \
  git \
  jq \
  which \
  python3-requests \
  unzip \
  which \
  xorg-x11-server-Xvfb \
  zip && rm -rf /var/cache/yum

# Install gradle
RUN curl -f -s "https://get.sdkman.io" | bash \
&& source "/root/.sdkman/bin/sdkman-init.sh" \
&& sdk install gradle

RUN yum -q clean all
