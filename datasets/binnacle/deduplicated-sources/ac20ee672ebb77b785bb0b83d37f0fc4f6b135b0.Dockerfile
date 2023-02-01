FROM @BASE_IMAGE@

#
# Fix a few things for Conda
RUN { \
      echo '#!/bin/bash'; \
      echo 'set -ex'; \
      echo 'cp /root/.condarc /opt/conda'; \
      echo 'source /etc/profile.d/conda.sh';  \
      echo 'conda config --system --set always_copy True'; \
      echo 'echo "source /etc/profile.d/conda.sh" >> /etc/skel/.bashrc'; \
    } > /tmp/conda-fix-jenkins.sh \
    && chmod +x /tmp/conda-fix-jenkins.sh \
    && /tmp/conda-fix-jenkins.sh

#
# Install OpenJDK-headless
#
ENV JAVA_HOME /docker-java-home

ENV JAVA_VERSION 8u191
ENV JAVA_CENTOS_VERSION 1.8.0.191.b12-0.el6_10

COPY scripts/setup_openjdk /opt/docker/bin/setup_openjdk
RUN /opt/docker/bin/setup_openjdk

#
# Install Jenkin's remoting/slave
#
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG AGENT_VERSION=3.28
ARG AGENT_WORKDIR=/home/${user}/agent
ENV AGENT_WORKDIR=${AGENT_WORKDIR}

COPY scripts/setup_jenkins /opt/docker/bin/setup_jenkins
RUN /opt/docker/bin/setup_jenkins

USER ${user}
WORKDIR /home/${user}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}

COPY scripts/jenkins-slave /usr/local/bin/jenkins-slave
ENTRYPOINT ["/opt/conda/bin/tini", "--", "jenkins-slave"]
