FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y \
    python-docutils \
    cdbs \
    debootstrap \
    devscripts \
    make \
    pbuilder \
    python-jinja2 \
    python-setuptools \
    python-yaml \
    && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

VOLUME /ansible
WORKDIR /ansible

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["make deb"]
