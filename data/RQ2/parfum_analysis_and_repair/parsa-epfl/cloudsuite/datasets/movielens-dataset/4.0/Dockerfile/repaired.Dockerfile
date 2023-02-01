FROM cloudsuite/base-os:debian

# Download datasets
RUN BUILD_DEPS="curl unzip" \
    && set -x \
    && apt-get update -y && apt-get install -y --no-install-recommends ${BUILD_DEPS} \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /data \
    && curl -f -o /data/ml-latest-small.zip https://files.grouplens.org/datasets/movielens/ml-latest-small.zip \
    && unzip -d /data /data/ml-latest-small.zip \
    && rm /data/ml-latest-small.zip \
    && curl -f -o /data/ml-latest.zip https://files.grouplens.org/datasets/movielens/ml-latest.zip \
    && unzip -d /data /data/ml-latest.zip \
    && rm /data/ml-latest.zip \
    && apt-get purge -y --auto-remove ${BUILD_DEPS}

COPY files /data/

VOLUME ["/data"]
