ARG WORDPRESS_IMAGE_VERSION="latest"

FROM wordpress:${WORDPRESS_IMAGE_VERSION}

# Create a "docker" user and group that will map to the current user gid:uid.
# This will allow setting the `APACHE_RUN_USER`, and with it deal with filemode issues, correctly.
ARG DOCKER_RUN_UID=0
ARG DOCKER_RUN_GID=0
RUN if [ "${DOCKER_RUN_GID}" != 0 ]; then addgroup --gid ${DOCKER_RUN_GID} docker; fi; \
    if [ "${DOCKER_RUN_UID}" != 0 ]; then adduser --uid ${DOCKER_RUN_UID} --gid ${DOCKER_RUN_GID} --home /home/docker \
                             --shell /bin/sh --disabled-password --gecos "" docker; fi