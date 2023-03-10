FROM __DEPS_IMAGE__

MAINTAINER Stephen Gallagher <sgallagh@redhat.com>

RUN yum -y --setopt=install_weak_deps=False --setopt=tsflags='' \
           --nogpgcheck install \
        rsync \
        ruby \
        rubygems \
        "rubygem(json)" \
        wget \
    && yum -y clean all

ARG TARBALL

ADD $TARBALL /builddir/

RUN  /builddir/.ci/coverity_prep.sh

ENTRYPOINT /builddir/.ci/coverity/ci-tasks.sh