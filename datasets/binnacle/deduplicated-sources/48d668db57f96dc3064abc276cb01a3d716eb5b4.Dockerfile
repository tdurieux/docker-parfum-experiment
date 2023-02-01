ARG IMAGE_REPO
FROM ${IMAGE_REPO:-lagoon}/commons as commons
FROM jboss/keycloak

USER root

RUN yum install -y nc \
    && yum clean all \
    && rm -rf /var/cache/yum

LABEL maintainer="amazee.io"
ENV LAGOON=keycloak

# Copy commons files
COPY --from=commons /lagoon /lagoon
COPY --from=commons /bin/fix-permissions /bin/ep /bin/docker-sleep /bin/
COPY --from=commons /home /home

RUN chmod g+w /etc/passwd \
    && mkdir -p /home

# Fix permissions for JBoss home directory
RUN chgrp -R 0 $JBOSS_HOME &&\
    chmod -R g+rw $JBOSS_HOME

# Reproduce behavior of Alpine: Run Bash as sh
RUN rm -f /bin/sh && ln -s /bin/bash /bin/sh

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod +x /sbin/tini

ENV TMPDIR=/tmp \
    TMP=/tmp \
    HOME=/home \
    # When Bash is invoked via `sh` it behaves like the old Bourne Shell and sources a file that is given in `ENV`
    ENV=/home/.bashrc \
    # When Bash is invoked as non-interactive (like `bash -c command`) it sources a file that is given in `BASH_ENV`
    BASH_ENV=/home/.bashrc \
    KEYCLOAK_ADMIN_USER=admin \
    KEYCLOAK_ADMIN_PASSWORD=admin \
    KEYCLOAK_REALM=lagoon \
    KEYCLOAK_REALM_ROLES=admin \
    DB_ADDR=keycloak-db \
    DB_USER=keycloak \
    DB_PASSWORD=keycloak \
    DB_DATABASE=keycloak \
    KEYCLOAK_LAGOON_ADMIN_USERNAME=lagoonadmin \
    KEYCLOAK_LAGOON_ADMIN_PASSWORD=lagoonadmin \
    PROXY_ADDRESS_FORWARDING=true

VOLUME /opt/jboss/keycloak/standalone/data

COPY start.sh /opt/jboss/tools/start.sh
COPY wait-for-mariadb.sh /lagoon/entrypoints/99-wait-for-mariadb.sh

ENTRYPOINT ["/sbin/tini", "--", "/lagoon/entrypoints.bash"]
CMD ["/opt/jboss/tools/start.sh"]
