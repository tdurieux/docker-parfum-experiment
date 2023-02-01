FROM registry.fedoraproject.org/fedora:29

ENV PYTHONDONTWRITEBYTECODE=yes-please

RUN dnf install -y \
    make python3-pytest python3-pyxattr python3-pytest-cov \
    skopeo podman buildah atomic \
    python3-ipdb \
    && dnf clean all

RUN sed '/^graphroot/s/.*/graphroot="\/var\/tmp\/containers"/' -i /etc/containers/storage.conf \
    && printf 'checkout_path: /var/tmp/containers/atomic\n' >>/etc/atomic.conf

# # podman
# RUN useradd podm
# RUN echo "podm:231072:65536" > /etc/subuid
# RUN echo "podm:231072:65536" > /etc/subgid
# USER podm

WORKDIR /src

COPY . /src

RUN pip3 install --user .
