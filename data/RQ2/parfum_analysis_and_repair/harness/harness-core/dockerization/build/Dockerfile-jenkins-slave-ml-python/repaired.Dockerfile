FROM jenkins/jnlp-slave

USER root

RUN apt-get update && \
    apt-get install --no-install-recommends -y make && \
    apt-get install --no-install-recommends -y protobuf-compiler && \
    apt-get -y --no-install-recommends install python3-pip && \
    pip3 install --no-cache-dir yapf && rm -rf /var/lib/apt/lists/*;

ENV DOCKER_VERSION latest

USER root
RUN curl -f -sSL -o /tmp/docker-${DOCKER_VERSION}.tgz https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz \
    && tar xzf /tmp/docker-${DOCKER_VERSION}.tgz -C /tmp \
    && rm /tmp/docker-${DOCKER_VERSION}.tgz \
    && chmod -R +x /tmp/docker/ \
    && mv /tmp/docker/* /usr/bin/

USER jenkins