FROM __DEPS_IMAGE__

MAINTAINER Tomasz Paweł Gajc <tpgxyz@gmail.com>

ARG TARBALL

ADD $TARBALL /builddir/

ENTRYPOINT /builddir/.ci/openmandriva/ci-tasks.sh