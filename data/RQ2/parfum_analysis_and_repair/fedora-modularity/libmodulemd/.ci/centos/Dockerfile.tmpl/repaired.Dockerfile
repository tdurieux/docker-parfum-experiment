FROM __DEPS_IMAGE__

MAINTAINER Stephen Gallagher <sgallagh@redhat.com>

ARG TARBALL

ADD $TARBALL /builddir/

ENTRYPOINT /builddir/.ci/centos/ci-tasks.sh