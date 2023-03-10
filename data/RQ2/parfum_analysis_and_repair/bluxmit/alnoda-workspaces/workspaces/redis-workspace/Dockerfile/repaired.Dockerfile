ARG docker_registry=docker.io/alnoda
ARG image_tag=2.2

## Images used:
ARG BUILD_IMAGE=node:12.18.3
ARG DEPLOY_IMAGE=${docker_registry}/base-workspace:${image_tag}
ARG MKDOCS_COPY_IMAGE=${docker_registry}/ide-workspace:${image_tag}

################################################################################ BUILD

ARG THEIA_VERSION=1.15.0
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
    NODE_OPTIONS="--max_old_space_size=8192" yarn theia build && \
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
COPY supervisord-redis-wid.conf /etc/supervisord/

COPY --from=docs_image /home/docs/ /home/docs/
COPY ./mkdocs/mkdocs.yml /home/docs/mkdocs.yml
COPY ./mkdocs/helpers.py /home/docs/macros
COPY ./mkdocs/Redis-commander.png /home/docs/docs/assets/home/
COPY ./mkdocs/README.md /home/docs/docs/README.md

ENV SHELL=/bin/bash \
    THEIA_DEFAULT_PLUGINS=local-dir:/opt/theia/plugins \ 
    USE_LOCAL_GIT=true \
    HOME=/home/abc \
    PATH="/home/abc/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    NVM_DIR=/home/abc/.nvm

RUN apt-get -y update \
    # && echo "------------------------------------------------------ utils" \
    # && rm -rf /home/abc/utils || true \
    # && git clone https://github.com/bluxmit/alnoda-workspaces /tmp/alnoda-workspaces \
    # && mv /tmp/alnoda-workspaces/utils /home/abc/ \
    # && rm -rf /tmp/alnoda-workspaces \
    && echo "------------------------------------------------------ local redis" \
    && apt-get -y --no-install-recommends install redis-server \
    && echo "------------------------------------------------------ redis tools" \
    && apt-get -y --no-install-recommends install redis-tools \
    && pip install --no-cache-dir iredis==1.10.0 \
    && echo "------------------------------------------------------ redis-dump" \
    && cd /tmp && wget https://github.com/yannh/redis-dump-go/releases/download/v0.6.0/redis-dump-go-linux-amd64.tar.gz \
    && tar -xzf redis-dump-go-linux-amd64.tar.gz \
    && chmod +x redis-dump-go \
    && mv /tmp/redis-dump-go /usr/bin/redis-dump-go \
    && rm /tmp/redis-dump-go-linux-amd64.tar.gz \
    && echo "------------------------------------------------------ redis-tui" \
    && cd /tmp && wget https://github.com/mylxsw/redis-tui/releases/download/0.1.6/redis-tui-linux \
    && chmod +x /tmp/redis-tui-linux \
    && mv /tmp/redis-tui-linux /usr/bin/redis-tui \
    && rm -rf /tmp/redis-tui-linux \
    && echo "------------------------------------------------------ redis-commander" \
    && mkdir -p -m 777 /opt/redis-commander \
    && cd /opt/redis-commander && nodeenv --node=12.18.3 env && . env/bin/activate \
    && npm install -g redis-commander@0.7.2 \
    && echo "------------------------------------------------------ user" \
    && chown -R abc /opt/theia \
    && mkdir -p /var/log/theia && chown -R abc /var/log/theia \
    && mkdir -p /var/log/redis && chown -R abc /var/log/redis \
    && mkdir -p /opt/redis && chown -R abc /opt/redis \
    && chmod 777 /var/lib/redis \
    && mkdir -p /home/redis-data && chown -R abc /home/redis-data \
    && chown -R abc /opt/redis-commander \
    && mkdir -p /var/log/redis-commander && chown -R abc /var/log/redis-commander \
    && chown -R abc /home/docs \
    && chown -R abc /home/abc/utils \
    && chown -R abc /home/abc/installed-python-packages \
    && find /home -type d | xargs -I{} chown -R abc {} \
    && find /home -type f | xargs -I{} chown abc {} && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

USER abc

COPY redis.conf /opt/redis/redis.conf

