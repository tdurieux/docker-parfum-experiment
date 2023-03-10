FROM registry.access.redhat.com/ubi8

# This is the release of Vault to pull in.
ARG VAULT_BASE_VERSION

LABEL name="JFrog Pipelines Vault" \
      description="JFrog Pipelines Vault image based on the Red Hat Universal Base Image." \
      vendor="JFrog" \
      summary="JFrog Pipelines Vault (Red Hat UBI)" \
      com.jfrog.license_terms="https://jfrog.com/platform/enterprise-plus-eula/"

ENV JF_VAULT_USER=vault \
    JF_VAULT_USER_GROUP=vault \
    VAULT_USER_ID=1000721117 \
    VAULT_VERSION=${VAULT_BASE_VERSION}

# Create a vault user and group first so the IDs get set the same way,
# even as the rest of this may change over time.
RUN useradd -M -s /usr/sbin/nologin --uid ${VAULT_USER_ID} --user-group ${JF_VAULT_USER_GROUP}
RUN mkdir -p /home/${JF_VAULT_USER} && \
    chown -R ${VAULT_USER_ID}:${VAULT_USER_ID} /home/${JF_VAULT_USER}

RUN yum install -y --disableplugin=subscription-manager wget curl unzip ca-certificates gnupg openssl libcap tzdata && rm -rf /var/cache/yum

# Set up certificates, our base tools, and Vault.
RUN set -eux; \
    apkArch="$(uname -a)"; \
    case "$apkArch" in \
        armhf) ARCH='arm' ;; \
        aarch64) ARCH='arm64' ;; \
        x86_64) x86_64 ;; \
        x86) ARCH='386' ;; \
        *) echo >&2 "Supported architecture: $apkArch" ;; \
    esac && \
    VAULT_GPGKEY=91A6E7F85D05C65630BEF18951852D87348FFC4C; \
    found=''; \
    for server in \
        hkp://p80.pool.sks-keyservers.net:80 \
        hkp://keyserver.ubuntu.com:80 \
        hkp://pgp.mit.edu:80 \
    ; do \
        echo "Fetching GPG key $VAULT_GPGKEY from $server"; \
        gpg --batch --keyserver "$server" --recv-keys "$VAULT_GPGKEY" && found=yes && break; \
    done; \
    test -z "$found" && echo >&2 "error: failed to fetch GPG key $VAULT_GPGKEY" && exit 1; \
    mkdir -p /tmp/build && \
    cd /tmp/build && \
    wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig && \
    gpg --batch --verify vault_${VAULT_VERSION}_SHA256SUMS.sig vault_${VAULT_VERSION}_SHA256SUMS && \
    grep vault_${VAULT_VERSION}_linux_amd64.zip vault_${VAULT_VERSION}_SHA256SUMS | sha256sum -c && \
    unzip -d /bin vault_${VAULT_VERSION}_linux_amd64.zip && \
    cd /tmp && \
    rm -rf /tmp/build && \
    gpgconf --kill dirmngr && \
    gpgconf --kill gpg-agent && \
    rm -rf /root/.gnupg

# /vault/logs is made available to use as a location to store audit logs, if
# desired; /vault/file is made available to use as a location with the file
# storage backend, if desired; the server will be started with /vault/config as
# the configuration directory so you can add additional config files in that
# location.
RUN mkdir -p /vault/logs && \
    mkdir -p /vault/file && \
    mkdir -p /vault/config && \
    chown -R vault:vault /vault

# Expose the logs directory as a volume since there's potentially long-running
# state in there
VOLUME /vault/logs

# Expose the file directory as a volume since there's potentially long-running
# state in there
VOLUME /vault/file

# 8200/tcp is the primary interface that applications use to interact with
# Vault.
EXPOSE 8200

# The entry point script uses dumb-init as the top-level process to reap any
# zombie processes created by Vault sub-processes.
#
# For production derivatives of this container, you shoud add the IPC_LOCK
# capability so that Vault can mlock memory.
COPY vault-docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Add EULA information to meet the Red Hat container image certification requirements
COPY entplus_EULA.txt /licenses/

# SETUP VAULT TO USE MLOCK
RUN setcap cap_ipc_lock=+ep $(readlink -f $(which vault))

USER ${JF_VAULT_USER}
ENTRYPOINT ["docker-entrypoint.sh"]

# By default you'll get a single-node development server that stores everything
# in RAM and bootstraps itself. Don't use this configuration for production.
CMD ["server", "-dev"]