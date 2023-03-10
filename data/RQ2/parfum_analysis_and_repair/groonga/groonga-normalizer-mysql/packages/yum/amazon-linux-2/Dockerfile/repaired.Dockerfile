ARG FROM=amazonlinux:2
FROM ${FROM}

ARG DEBUG

RUN \
  quiet=$([ "${DEBUG}" = "yes" ] || echo "--quiet") && \
  amazon-linux-extras install -y ${quiet} epel && \
  yum install -y ${quiet} ca-certificates && \
  yum install -y ${quiet} \
    https://packages.groonga.org/amazon-linux/2/groonga-release-latest.noarch.rpm && \
  yum update -y ${quiet} && \
  yum groupinstall -y ${quiet} "Development Tools" && \
  yum install -y ${quiet} \
    groonga-devel && \
  yum clean ${quiet} all && rm -rf /var/cache/yum
