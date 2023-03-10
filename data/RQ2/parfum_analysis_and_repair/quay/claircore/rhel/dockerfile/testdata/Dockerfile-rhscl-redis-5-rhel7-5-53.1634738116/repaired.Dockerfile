FROM sha256:80f381f67fab035e7df9e0714aca8a13b49af52f40482fadcfb893b50740272c

# Redis image based on Software Collections packages
#
# Volumes:
#  * /var/lib/redis/data - Datastore for Redis
# Environment:
#  * $REDIS_PASSWORD - Database password

ENV REDIS_VERSION=5 \
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
      io.k8s.display-name="Redis 5" \
      io.openshift.expose-services="6379:redis" \
      io.openshift.tags="database,redis,redis5,rh-redis5" \
      com.redhat.component="rh-redis5-container" \
      name="rhscl/redis-5-rhel7" \
      version="5" \
      com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#rhel" \
      usage="podman run -d --name redis_database -p 6379:6379 rhscl/redis-5-rhel7" \
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
RUN getent group  redis & > /dev/null || groupadd -r redis & > /dev/null && \
    usermod -l redis -aG redis -c 'Redis Server' default & > /dev/null && \
# Install gettext for envsubst command
    yum install -y yum-utils gettext && \
    prepare-yum-repositories rhel-server-rhscl-7-rpms && \
    INSTALL_PKGS="rh-redis5" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && \
    mkdir -p /var/lib/redis/data && chown -R redis.0 /var/lib/redis && \
    [[ "$(id redis)" == "uid=1001(redis)"* ]] && rm -rf /var/cache/yum

# Get prefix path and path to scripts rather than hard-code them in scripts
ENV CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/redis \
    REDIS_PREFIX=/opt/rh/rh-redis5/root/usr \
    ENABLED_COLLECTIONS=rh-redis5

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

ADD help.1 /help.1
ADD rh-redis5-container-5-53.1634738116.json /root/buildinfo/content_manifests/rh-redis5-container-5-53.1634738116.json
LABEL "release"="53.1634738116" "distribution-scope"="public" "vendor"="Red Hat, Inc." "build-date"="2021-10-20T13:56:03.899740" "architecture"="x86_64" "vcs-type"="git" "vcs-ref"="1ca08b535089c4828147120ead2699d9f237260a" "com.redhat.build-host"="cpt-1007.osbs.prod.upshift.rdu2.redhat.com" "url"="https://access.redhat.com/containers/#/registry.access.redhat.com/rhscl/redis-5-rhel7/images/5-53.1634738116"
