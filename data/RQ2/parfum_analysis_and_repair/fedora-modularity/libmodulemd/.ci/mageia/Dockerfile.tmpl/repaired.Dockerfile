FROM __DEPS_IMAGE__

MAINTAINER Stephen Gallagher <sgallagh@redhat.com>

ARG TARBALL

ADD $TARBALL /builddir/

ENTRYPOINT /builddir/.ci/mageia/ci-tasks.sh