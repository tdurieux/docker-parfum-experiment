FROM quay.io/centos7/s2i-core-centos7

# Redis image based on Software Collections packages
#
# Volumes:
#  * /var/lib/redis/data - Datastore for Redis
# Environment:
#  * $REDIS_PASSWORD - Database password

ENV REDIS_VERSION=6 \
    HOME=/var/lib/redis

ENV SUMMARY="Redis in-memory data structure store, used as database, cache and message broker" \
    DESCRIPTION="Redis $REDIS_VERSION available as container, is an advanced key-value store. \
It is often referred to as a data structure server since keys can contain strings, hashes, lists, \
sets and sorted sets. You can run atomic operations on these types, like appending to a string; \
incrementing the value in a hash; pushing to a list; computing set intersection, union and difference; \
or getting the member with highest ranking in a sorted set. In order to achieve its outstanding \
performance, Redis works with an in-memory dataset. Depending on your use case, you can persist \
it either by dumping the dataset to disk every once in a while, or by appending each command to a log."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Redis 6" \
      io.openshift.expose-services="6379:redis" \
      io.openshift.tags="database,redis,redis6,rh-redis6" \
      com.redhat.component="rh-redis6-container" \
      name="centos7/redis-6-centos7" \
      version="6" \
      usage="podman run -d --name redis_database -p 6379:6379 quay.io/centos7/redis-6-centos7" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

EXPOSE 6379

# Create user for redis that has known UID
# We need to do this before installing the RPMs which would create user with random UID
# The UID is the one used by the default user from the parent layer (1001),
# and since the user exists already, do not create a new one, but only rename
# the existing
# This image must forever use UID 1001 for redis user so our volumes are
# safe in the future. This should *never* change, the last test is there
# to make sure of that.
RUN getent group  redis &> /dev/null || groupadd -r redis &> /dev/null && \
    usermod -l redis -aG redis -c 'Redis Server' default &> /dev/null && \
# Install gettext for envsubst command
    yum install -y yum-utils gettext && \
    yum install -y centos-release-scl && \
    INSTALL_PKGS="rh-redis6" && \
    yum install -y --setopt=tsflags=nodocs --nogpgcheck $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && \
    mkdir -p /var/lib/redis/data && chown -R redis.0 /var/lib/redis && \
    [[ "$(id redis)" == "uid=1001(redis)"* ]]

# Get prefix path and path to scripts rather than hard-code them in scripts
ENV CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/redis \
    REDIS_PREFIX=/opt/rh/rh-redis6/root/usr \
    ENABLED_COLLECTIONS=rh-redis6 \
    REDIS_CONF=/etc/redis.conf

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ENV BASH_ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
    ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
    PROMPT_COMMAND=". ${CONTAINER_SCRIPTS_PATH}/scl_enable"

COPY root /

# this is needed due to issues with squash
# when this directory gets rm'd by the container-setup
# script.
RUN /usr/libexec/container-setup

VOLUME ["/var/lib/redis/data"]

# Using a numeric value because of a comment in [1]:
# If your S2I image does not include a USER declaration with a numeric user,
# your builds will fail by default.
# [1] https://docs.openshift.com/container-platform/4.4/openshift_images/create-images.html#images-create-guide-openshift_create-images
USER 1001

ENTRYPOINT ["container-entrypoint"]
CMD ["run-redis"]
