FROM blacklabelops/rsnapshot
MAINTAINER Steffen Bleul <blacklabelops@itbleul.de>

# build parameters
ARG JOBBER_VERSION=v1.1

RUN export JOBBER_HOME=/tmp/jobber && \
    export JOBBER_LIB=$JOBBER_HOME/lib && \
    export GOPATH=$JOBBER_LIB && \
    export CONTAINER_UID=1000 && \
    export CONTAINER_GID=1000 && \
    export CONTAINER_USER=jobber_client && \
    export CONTAINER_GROUP=jobber_client && \
    # Install tools
    apk add --no-cache --update \
      go \
      musl-dev \
      git \
      curl \
      wget \
      make && \
    mkdir -p $JOBBER_HOME && \
    mkdir -p $JOBBER_LIB && \
    # Install Jobber
    addgroup -g $CONTAINER_GID jobber_client && \
    adduser -u $CONTAINER_UID -G jobber_client jobber_client -s /bin/bash -S && \
    cd $JOBBER_LIB && \
    go get github.com/dshearer/jobber; true && \
    if  [ "${JOBBER_VERSION}" != "latest" ]; \
      then \
        # wget --directory-prefix=/tmp https://github.com/dshearer/jobber/releases/download/v1.1/jobber-${JOBBER_VERSION}-r0.x86_64.apk && \
        # apk add --allow-untrusted /tmp/jobber-${JOBBER_VERSION}-r0.x86_64.apk ; \
        cd src/github.com/dshearer/jobber && \
        git checkout tags/${JOBBER_VERSION} && \
        cd $JOBBER_LIB ; \
    fi && \
    make -C src/github.com/dshearer/jobber install DESTDIR=$JOBBER_HOME && \
    cp $JOBBER_LIB/bin/* /usr/bin && \
    # Install Tini Zombie Reaper And Signal Forwarder
    export TINI_VERSION=0.9.0 && \
    export TINI_SHA=fa23d1e20732501c3bb8eeeca423c89ac80ed452 && \
    curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static -o /bin/tini && \
    chmod +x /bin/tini && \
    # Cleanup
    apk del \
      go \
      git \
      curl \
      wget \
      make && \
    rm -rf /var/cache/apk/* && rm -rf /tmp/* && rm -rf /var/log/*

ENV PATH=$PATH:/opt/jobber/lib/bin \
    CRON_HOURLY= \
    CRON_DAILY= \
    CRON_WEEKLY= \
    CRON_MONTHLY=

COPY docker-entrypoint.sh /usr/bin/cron.d/docker-entrypoint.sh
COPY rsnapshot.sh /usr/bin/rsnapshot.d/rsnapshot.sh
ENTRYPOINT ["/usr/bin/cron.d/docker-entrypoint.sh"]
VOLUME ["${VOLUME_DIRECTORY}"]
CMD ["rsnapshotd"]
