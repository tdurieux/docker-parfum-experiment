FROM ubuntu:latest
LABEL maintainer="John Gruber <j.gruber@f5.com>"

WORKDIR /

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y libguestfs-tools \
    qemu-utils \
    linux-image-generic \
    virtualbox \
    python-ipython \
    python-openstackclient \
    python-guestfs \
    python-jsonschema \
    python-yaml \
    python-pip \
    python-setuptools \
    git

## INJECT_PATCH_INSTRUCTION ##
RUN git clone https://github.com/jgruber/tmos-cloudinit.git
RUN pip install pycdlib

ENV LIBGUESTFS_BACKEND=direct

VOLUME ["/TMOSImages", "/iControlLXPackages", "/TMOS_usr", "/TMOS_config"]

ENV TMOS_IMAGE_DIR '/TMOSImages'
ENV TMOS_ICONTROLLX_DIR '/iControlLXPackages'
ENV TMOS_USR_INJECT_DIR '/tmos-cloudinit/image_patch_files/usr'
ENV USER 'root'
ENV UPDATE_CLOUDINIT 'true'

ENTRYPOINT [ "/tmos-cloudinit/tmos_image_patcher/tmos_image_patcher.py" ]

