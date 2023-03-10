FROM registry.fedoraproject.org/fedora:32

ENV PYTHONDONTWRITEBYTECODE=yes-please

RUN dnf install -y --setopt=install_weak_deps=False --disablerepo=fedora-cisco-openh264 \
    make python3-pytest python3-pyxattr python3-pytest-cov \
    python3-pip \
    skopeo podman buildah runc \
    python3-ipdb \
    && dnf clean all \
    && curl -f -L -o /usr/local/bin/umoci https://github.com/opencontainers/umoci/releases/download/v0.4.6/umoci.amd64 \
    && chmod a+x /usr/local/bin/umoci

RUN cp /usr/share/containers/containers.conf /etc/containers/containers.conf \
# remove unnecessary warning due to missing unix socket to journald
# ERRO[0001] unable to write build event: "write unixgram @00656->/run/systemd/journal/socket: sendmsg: no such file or directory"
    && sed -e '/events_logger =/s/^.*$/events_logger = "file"/' -i /etc/containers/containers.conf \
# Error: 'overlay' is not supported over overlayfs, a mount_program is required: backing file system is unsupported for this graph driver
    && sed '/^graphroot/s/.*/graphroot="\/var\/tmp\/containers"/' -i /etc/containers/storage.conf \
# Failure on CentOS 7
# Error: failed to mount overlay for metacopy check with "nodev,metacopy=on" options: invalid argument
    && sed -e '/mountopt/s/,\?metacopy=on,\?//' -i /etc/containers/storage.conf

# # podman
# RUN useradd podm
# RUN echo "podm:231072:65536" > /etc/subuid
# RUN echo "podm:231072:65536" > /etc/subgid
# USER podm

WORKDIR /src

COPY . /src

RUN pip3 install --no-cache-dir --user .
