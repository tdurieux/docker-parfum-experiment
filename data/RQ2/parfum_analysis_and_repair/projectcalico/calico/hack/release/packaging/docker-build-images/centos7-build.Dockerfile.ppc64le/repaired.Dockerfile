FROM ppc64le/centos:7
MAINTAINER Shaun Crampton <shaun@tigera.io>
ENV STREAM el7

ARG UID
ARG GID

# Some commands that would typically be run at container build time must be run in a privileged container.
# Therefore, we do a two step image build process, in step 1 (now) scripts are placed in the image, in step 2
# a privileged container is started and the scripts are executed.

ADD install-centos-build-deps install-centos-build-deps

# rpmbuild requires the current user to exist inside the container, copy in
# some user/group entries calculated by the makefile.
# use `--force` and `-o` since tests can run under root and command will fail with duplicate error

RUN echo "#!/usr/bin/env bash" > /setup-user; \
    echo "groupadd --force --gid=$GID user && useradd -o --home=/ --gid=$GID --uid=$UID user" >> /setup-user; \
    chmod +x /setup-user

WORKDIR /code