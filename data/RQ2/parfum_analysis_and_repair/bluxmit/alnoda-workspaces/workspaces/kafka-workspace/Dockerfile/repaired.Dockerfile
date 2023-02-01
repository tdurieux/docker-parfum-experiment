ARG docker_registry=docker.io/alnoda
ARG image_tag=2.2

## Images used:
ARG BUILD_IMAGE=node:12.18.3
ARG DEPLOY_IMAGE=${docker_registry}/base-workspace:${image_tag}
ARG MKDOCS_COPY_IMAGE=${docker_registry}/ide-workspace:${image_tag}

################################################################################ BUILD

ARG THEIA_VERSION=1.15.0
#ARG THEIA_VERSION=latest
#ARG THEIA_VERSION=next
FROM ${BUILD_IMAGE}

ARG THEIA_VERSION

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y apt-utils \
    && apt-get install --no-install-recommends -y git \
    && apt-get install --no-install-recommends -y libsecret-1-dev \
    && mkdir /opt/theia && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/theia
ADD ${THEIA_VERSION}.package.json ./package.json
ARG GITHUB_TOKEN
RUN yarn --pure-lockfile && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && \
    yarn theia download:plugins && \
    yarn --production && \
    yarn autoclean --init && \
    echo *.ts >> .yarnclean && \
    echo *.ts.map >> .yarnclean && \
    echo *.spec.* >> .yarnclean && \
    yarn autoclean --force && \
    yarn cache clean


################################################################################ IMAGE

FROM ${MKDOCS_COPY_IMAGE} as docs_image
FROM ${DEPLOY_IMAGE}

USER root

RUN mkdir -p -m 777 /opt/theia \
    && cd /opt/theia && nodeenv --node=12.18.3 env && . env/bin/activate \
    && mkdir -p -m 777 /home/project \
    && apt-get install --no-install-recommends -y libsecret-1-dev \
    && rm -rf /home/docs && rm -rf /var/lib/apt/lists/*;

COPY --from=0 /opt/theia /opt/theia
COPY settings.json /home/abc/.theia/settings.json
COPY supervisord-kafka-wid.conf /etc/supervisord/

COPY --from=docs_image /home/docs/ /home/docs/
COPY ./mkdocs/mkdocs.yml /home/docs/mkdocs.yml

ENV SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=local-dir:/opt/theia/plugins \ 
    USE_LOCAL_GIT=true \
    HOME=/home/abc \
    PATH="/home/abc/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    NVM_DIR=/home/abc/.nvm

RUN echo "------------------------------------------------------ java" \
    && apt-get -y update \
    && cd /tmp && wget https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz \
    && tar xvf openjdk-17.0.2_linux-x64_bin.tar.gz \
    && rm -rf openjdk-17.0.2_linux-x64_bin.tar.gz \
    && mv /tmp/jdk-17.0.2/ /opt/jdk-17/ \
    && echo "------------------------------------------------------ kafka" \
    && cd /tmp && wget https://dlcdn.apache.org/kafka/3.1.0/kafka_2.13-3.1.0.tgz \
    && tar -xzf kafka_2.13-3.1.0.tgz \
    && mv kafka_2.13-3.1.0 /opt/kafka \
    && rm kafka_2.13-3.1.0.tgz \
    && echo "------------------------------------------------------ kafkacat" \
    && apt-get -y --no-install-recommends install kafkacat \
    && echo "------------------------------------------------------ kt" \
    && cd /tmp && wget https://github.com/fgeller/kt/releases/download/v13.0.0/kt-v13.0.0-linux-amd64.txz \
    && tar Jxvf kt-v13.0.0-linux-amd64.txz \
    && chmod +x /tmp/kt \
    && mv /tmp/kt /usr/bin/kt \
    && rm /tmp/kt-v13.0.0-linux-amd64.txz \
    && echo "------------------------------------------------------ kafkactl" \
    && cd /tmp && wget https://github.com/deviceinsight/kafkactl/releases/download/v1.24.0/kafkactl_1.24.0_linux_386.tar.gz \
    && tar -xzf kafkactl_1.24.0_linux_386.tar.gz \
    && chmod +x /tmp/kafkactl \
    && mv /tmp/kafkactl /usr/bin/kafkactl \
    && rm /tmp/kafkactl_1.24.0_linux_386.tar.gz \
    && echo "------------------------------------------------------ kcli" \
    && cd /tmp && wget https://github.com/cswank/kcli/releases/download/1.8.3/kcli_1.8.3_Linux_x86_64.tar.gz \
    && tar -xzf kcli_1.8.3_Linux_x86_64.tar.gz \
    && chmod +x /tmp/kcli \
    && mv /tmp/kcli /usr/bin/kcli \
    && rm kcli_1.8.3_Linux_x86_64.tar.gz \
    && echo "------------------------------------------------------ trubka" \
    && cd /tmp && wget https://github.com/xitonix/trubka/releases/download/v3.2.1/trubka_3.2.1_linux_amd64.tar.gz \
    && tar -xzf trubka_3.2.1_linux_amd64.tar.gz \
    && chmod +x /tmp/trubka \
    && mv /tmp/trubka /usr/bin/trubka \
    && rm trubka_3.2.1_linux_amd64.tar.gz \
    # && echo "------------------------------------------------------ alnoda utils" \
    # && rm -rf /home/abc/utils || true \
    # && git clone https://github.com/bluxmit/alnoda-workspaces /tmp/alnoda-workspaces \
    # && mv /tmp/alnoda-workspaces/utils /home/abc/ \
    # && rm -rf /tmp/alnoda-workspaces \
    && echo "------------------------------------------------------ user" \
    && chown -R abc /opt/theia \
    && mkdir -p /var/log/theia && chown -R abc /var/log/theia \
    && mkdir -p /var/log/zookeeper/ && chown -R abc /var/log/zookeeper/ \
    && mkdir -p /var/log/kafka && chown -R abc /var/log/kafka \
    && chown -R abc /opt/kafka \
    && chown -R abc /home/docs \
    && chown -R abc /home/abc/utils \
    && chown -R abc /home/abc/installed-python-packages \
    && find /home -type d | xargs -I{} chown -R abc {} \
    && find /home -type f | xargs -I{} chown abc {} && rm -rf /var/lib/apt/lists/*;

ENV export JAVA_HOME=/opt/jdk-17
ENV PATH="/opt/jdk-17/bin:$PATH"

USER abc





