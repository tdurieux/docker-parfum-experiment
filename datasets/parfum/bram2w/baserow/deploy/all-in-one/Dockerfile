ARG FROM_BACKEND_IMAGE=baserow_backend
ARG FROM_WEBFRONTEND_IMAGE=baserow_web-frontend
# This is pinned as version pinning is done by the CI setting FROM_IMAGE.
# hadolint ignore=DL3006
FROM $FROM_BACKEND_IMAGE as backend_image_base
# hadolint ignore=DL3006
FROM $FROM_WEBFRONTEND_IMAGE as web_frontend_image_base
FROM debian:buster-slim as base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG UID
ENV UID=${UID:-9999}
ARG GID
ENV GID=${GID:-9999}
ARG DOCKER_USER
ENV DOCKER_USER=${DOCKER_USER:-baserow_docker_user}

ENV DATA_DIR=/baserow/data
ENV BASEROW_PLUGIN_DIR=$DATA_DIR/plugins
ENV POSTGRES_VERSION=11
ENV POSTGRES_LOCATION=/etc/postgresql/11/main
ENV BASEROW_IMAGE_TYPE="all-in-one"

# ========================
# = APT-GET UPDATE/UPGRADE/INSTALL DEPS + NODE + CADDY
# ========================
RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install --no-install-recommends -y \
    make supervisor curl gnupg2 \
    build-essential \
    libpq-dev \
    redis-server \
    postgresql \
    postgresql-contrib \
    postgresql-client \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    ca-certificates \
    tini \
    psmisc \
    gosu \
    nano \
    vim \
    gawk \
    git \
    && \
    # ========================
    # Install Node and Yarn
    # ========================
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* &&  \
    npm install --global yarn@1.22.19 && \
    # ========================
    # Install Caddy
    # ========================
    curl -o caddy.tar.gz -sL https://github.com/caddyserver/caddy/releases/download/v2.4.6/caddy_2.4.6_linux_amd64.tar.gz && \
    tar -xf caddy.tar.gz && \
    mv caddy /usr/bin/ && \
    rm caddy.tar.gz && \
    # ========================
    # Setup Users
    # ========================
    ( groupadd -g "$GID" baserow_docker_group || true ) && \
    ( useradd --shell /bin/bash -u $UID -g "$GID" -o -c "" -m "$DOCKER_USER" -l || true) && \
    usermod -a -G tty "$DOCKER_USER" && \
    # ========================
    # Setup supervisor so it logs to stdout
    # ========================
    ln -sf /dev/stdout /var/log/supervisor/supervisord.log && \
    # ========================
    # Setup redis
    # ========================
    usermod -a -G tty redis && \
    # Ensure redis is not running in daemon mode as supervisor will supervise it directly
    sed -i 's/daemonize yes/daemonize no/g' /etc/redis/redis.conf && \
    # Ensure redis logs to stdout by removing any logfile statements
    sed -i 's/daemonize no/daemonize no\nbind 127.0.0.1/g' /etc/redis/redis.conf && \
    # Sedding changes the owner, change it back.
    sed -i '/^logfile/d' /etc/redis/redis.conf && \
    chown redis:redis /etc/redis/redis.conf

# In slim docker images, mime.types is removed and we need it for mimetypes guessing
COPY --chown=$UID:$GID ./backend/docker/mime.types /etc/

COPY --chown=$UID:$GID Caddyfile /baserow/caddy/Caddyfile

HEALTHCHECK --interval=60s CMD ["/bin/bash", "/baserow/backend/docker/docker-entrypoint.sh", "backend-healthcheck"]

# ========================
# = BASEROW
# ========================

# We have to explicitly copy the node modules and .nuxt build as otherwise the
# .dockerignore will exclude them.
COPY --chown=$UID:$GID --from=web_frontend_image_base /baserow/web-frontend/node_modules/ /baserow/web-frontend/node_modules/
COPY --chown=$UID:$GID --from=web_frontend_image_base /baserow/web-frontend/.nuxt/ /baserow/web-frontend/.nuxt/
COPY --chown=$UID:$GID --from=web_frontend_image_base /baserow/ /baserow/
COPY --chown=$UID:$GID --from=backend_image_base /baserow/ /baserow/


COPY --chown=$UID:$GID deploy/all-in-one/supervisor/ /baserow/supervisor

COPY --chown=$UID:$GID deploy/all-in-one/baserow.sh /baserow.sh
COPY --chown=$UID:$GID deploy/plugins/*.sh /baserow/plugins/
ENTRYPOINT ["/baserow.sh"]
CMD ["start"]
EXPOSE 80
