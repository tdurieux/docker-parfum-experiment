FROM themattrix/tox-base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT []