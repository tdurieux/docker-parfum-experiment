FROM __DEPS_IMAGE__

MAINTAINER Stephen Gallagher <sgallagh@redhat.com>

RUN dnf -y --setopt=install_weak_deps=False --nogpgcheck install rsync \
    && dnf -y clean all

ARG TARBALL

ADD $TARBALL /builddir/

ENTRYPOINT /builddir/.ci/docs/ci-tasks.sh