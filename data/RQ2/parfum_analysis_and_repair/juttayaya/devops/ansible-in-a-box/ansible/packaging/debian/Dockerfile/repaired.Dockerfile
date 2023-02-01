FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y \
    asciidoc \
    cdbs \
    debootstrap \
    devscripts \
    make \
    pbuilder \
    python-setuptools && rm -rf /var/lib/apt/lists/*;

VOLUME /ansible
WORKDIR /ansible

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["make deb"]
