FROM jenkinsci/jnlp-slave

ARG DOCKER_VERSION=5:19.03.5~3-0~debian-stretch
ARG DC_VERSION=1.25.1

ARG JFROG_USERNAME=?
ARG JFROG_PASSWORD=?

USER root
ENV HOME /root
RUN mkdir /root/.jenkins

RUN apt-get update && \
    apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" && \
    apt-get update && \
    apt-cache madison docker-ce && \
    apt-get install -qq -y --no-install-recommends docker-ce=${DOCKER_VERSION} && \
    curl -f -L https://github.com/docker/compose/releases/download/${DC_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    curl -f -X GET -u ${JFROG_USERNAME}:${JFROG_PASSWORD} https://harness.jfrog.io/artifactory/BuildsTools/docker/twistcli/twistcli -o /usr/local/bin/twistcli && \
    chmod +x /usr/local/bin/twistcli && \
    chmod +x /usr/local/bin/docker-compose && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install --no-install-recommends -y google-cloud-sdk && rm -rf /var/lib/apt/lists/*;

RUN curl -f -o gsutil.tar.gz https://storage.googleapis.com/pub/gsutil.tar.gz && \
    tar -xzf gsutil.tar.gz -C /opt && rm gsutil.tar.gz
ENV PATH ${PATH}:/opt/gsutil
