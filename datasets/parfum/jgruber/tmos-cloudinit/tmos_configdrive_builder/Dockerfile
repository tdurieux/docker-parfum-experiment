FROM ubuntu:latest
LABEL maintainer="John Gruber <j.gruber@f5.com>"

WORKDIR /

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    python-jsonschema \
    python-yaml \
    python-pip \
    python-setuptools \
    git

## INJECT_PATCH_INSTRUCTION ##
RUN git clone https://github.com/jgruber/tmos-cloudinit.git
RUN pip install pycdlib

ENV LIBGUESTFS_BACKEND=direct

VOLUME ["/declarations", "/configdrives"]

ENV USER 'root'

ENTRYPOINT [ "/tmos-cloudinit/tmos_configdrive_builder/tmos_configdrive_builder.py" ]

