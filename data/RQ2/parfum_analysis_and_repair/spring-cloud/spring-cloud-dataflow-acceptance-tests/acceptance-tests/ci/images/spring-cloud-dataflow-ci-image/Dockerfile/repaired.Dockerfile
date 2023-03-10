FROM openjdk:8u141-jdk

RUN apt-get update && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y libxml2-utils && \
    apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

ADD https://raw.githubusercontent.com/spring-io/concourse-java-scripts/v0.0.1/concourse-java.sh /opt/

ENV DOCKER_VERSION=17.12.0-ce \
    DOCKER_COMPOSE_VERSION=1.18.0 \
    ENTRYKIT_VERSION=0.4.0

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && \
    apt-get install --no-install-recommends -y libudev1 && \
    apt-get install --no-install-recommends -y iptables && \
    curl -f -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o docker-compose && \
    mv docker-compose /usr/bin/ && chmod +x /usr/bin/docker* && \
    curl -f https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz | tar zx && \
    mv /docker/* /usr/bin/ && chmod +x /usr/bin/docker* && rm -rf /var/lib/apt/lists/*;

# Install entrykit
RUN curl -f -L https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz | tar zx && \
    chmod +x entrykit && \
    mv entrykit /bin/entrykit && \
    entrykit --symlink

ARG BRANCH
ARG GITHUB_REPO_RAW
ARG BASE_PATH

ADD $GITHUB_REPO_RAW/$BRANCH/$BASE_PATH/ci/images/docker-lib.sh /docker-lib.sh

ENTRYPOINT [ \
    "switch", \
        "shell=/bin/sh", "--", \
    "codep", \
        "/bin/docker daemon" \
]
