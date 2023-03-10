ARG CONTAINER_IMAGE=opensuse/tumbleweed
FROM ${CONTAINER_IMAGE}

WORKDIR /build
COPY tox-requirements.txt .

RUN zypper --non-interactive dup
RUN zypper --non-interactive in \
  cpio \
  python3-tox \
  git \
  gcc \
  python3-devel \
  python-devel \
  python2-setuptools \
  python3-setuptools \
  python-xml
# librpmbuild%{librpmsover} package needed to build the RPM Python binding.
# https://build.opensuse.org/package/view_file/openSUSE:Factory/rpm/rpm.spec
# TODO: Install it in the process of rpm-py-installer.
RUN zypper --non-interactive in \
  librpmbuild9 \
  || true