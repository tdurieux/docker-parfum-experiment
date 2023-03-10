FROM registry.fedoraproject.org/fedora:31
LABEL maintainer="Randy Barlow <bowlofeggs@fedoraproject.org>"

RUN dnf install -y git-core golang-bin
RUN cd /repospanner && ./build.sh

CMD ["bash"]