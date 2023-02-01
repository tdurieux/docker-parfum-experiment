FROM ubuntu:16.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends openjdk-8-jre-headless -y && \
    apt-get install --no-install-recommends locales -y && \
    update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    apt-get clean all && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python openssh-server gnupg && rm -rf /var/lib/apt/lists/*;

ENV STORM_USER=storm \
    STORM_CONF_DIR=/conf \
    STORM_DATA_DIR=/data \
    STORM_LOG_DIR=/logs

# Add a user and make dirs
RUN set -x \
    && useradd  "$STORM_USER" \
    && mkdir -p "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR" \
    && chown -R "$STORM_USER:$STORM_USER" "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"

ARG DISTRO_NAME=apache-storm-1.2.1

# Download Apache Storm, verify its PGP signature, untar and clean up
RUN set -x \
    && wget -q "https://www.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz" \
    && tar -xzf "$DISTRO_NAME.tar.gz" \
    && chown -R "$STORM_USER:$STORM_USER" "$DISTRO_NAME" && rm "$DISTRO_NAME.tar.gz"

WORKDIR $DISTRO_NAME

ENV PATH $PATH:/$DISTRO_NAME/bin

RUN wget https://github.com/javabean/su-exec/releases/download/v0.2/su-exec.amd64 -O /usr/bin/su-exec
RUN chmod +x /usr/bin/su-exec

#
# FIXME: streamparse should be installed by virtualenv
#
RUN apt-get install --no-install-recommends -y python3-pip libffi-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir streamparse

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

WORKDIR /

ENTRYPOINT ["/docker-entrypoint.sh"]
