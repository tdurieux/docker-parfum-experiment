ARG FROM=amazonlinux:2
FROM ${FROM}

ARG DEBUG

RUN \
  quiet=$([ "${DEBUG}" = "yes" ] || echo "--quiet") && \
  amazon-linux-extras install -y ${quiet} \
    epel \
    postgresql12 && \
  yum install -y ${quiet} ca-certificates && \
  yum install -y ${quiet} \
    https://packages.groonga.org/amazon-linux/2/groonga-release-latest.noarch.rpm && \
  yum groupinstall -y ${quiet} "Development Tools" && \
  yum install -y ${quiet} \
    ccache \
    clang \
    groonga-devel \
    libpq-devel \
    llvm \
    msgpack-devel \
    postgresql-server-devel \
    xxhash-devel && \
  yum clean -y ${quiet} all && rm -rf /var/cache/yum
