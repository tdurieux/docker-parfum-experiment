FROM docker.io/library/centos:7

RUN yum install -y epel-release && yum install -y make python36 && yum clean all && rm -rf /var/cache/yum

WORKDIR /usr/src/app

COPY asciinema/ asciinema/
COPY tests/ tests/

ENV LANG="en_US.utf8"

USER nobody

ENTRYPOINT ["/bin/bash"]

# vim:ft=dockerfile
