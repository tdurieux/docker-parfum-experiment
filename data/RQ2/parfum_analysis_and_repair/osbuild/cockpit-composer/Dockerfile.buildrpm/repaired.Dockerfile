FROM fedora:latest
LABEL maintainer="Xiaofeng Wang" \
      email="xiaofwan@redhat.com" \
      baseimage="Fedora:latest" \
      description="A cockpit-composer RPM builder container running on Fedora"

RUN dnf install -y make cmake rpm-build which gnupg git tar xz rsync curl jq nodejs python gcc gcc-c++ libappstream-glib && dnf clean all

WORKDIR /composer
CMD ["make", "rpm", "srpm"]