# Create a Docker image that is ready to run the Randoop tests,
# using JDK 8.

FROM fedora
MAINTAINER Michael Ernst <mernst@cs.washington.edu>

# According to
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/:
#  * Put "apt-get update" and "apt-get install" in the same RUN command.
#  * Do not run "apt-get upgrade"; instead get upstream to update.

RUN dnf -qy upgrade \
&& dnf -qy install \
  java-1.8.0-openjdk \
  java-1.8.0-openjdk-devel

RUN dnf -qy upgrade \
&& dnf -qy install \
  findutils \
  git \
  jq \
  python3-requests \
  unzip \
  which \
  xorg-x11-server-Xvfb \
  zip

# Install gradle
RUN curl -f -s "https://get.sdkman.io" | bash \
&& source "/root/.sdkman/bin/sdkman-init.sh" \
&& sdk install gradle

RUN dnf -q clean all

RUN ([ -e /usr/lib/jvm/java-1.8.0-openjdk/jre/lib/security/cacerts ] || ln -s /etc/pki/java/cacerts /usr/lib/jvm/java-1.8.0-openjdk/jre/lib/security/cacerts)
