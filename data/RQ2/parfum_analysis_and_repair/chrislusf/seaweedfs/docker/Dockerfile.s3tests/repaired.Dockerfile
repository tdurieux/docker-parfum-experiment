FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        git \
        sudo \
        debianutils \
        python3-pip \
        python3-virtualenv \
        python3-dev \
        libevent-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        zlib1g-dev && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/ceph/s3-tests.git /opt/s3-tests

WORKDIR /opt/s3-tests
RUN ./bootstrap

ENV \
    NOSETESTS_EXCLUDE="" \
    NOSETESTS_ATTR="" \
    NOSETESTS_OPTIONS="" \
    S3TEST_CONF="/s3test.conf"

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["sleep 30 && exec ./virtualenv/bin/nosetests ${NOSETESTS_OPTIONS-} ${NOSETESTS_ATTR:+-a $NOSETESTS_ATTR} ${NOSETESTS_EXCLUDE:+-e $NOSETESTS_EXCLUDE}"]