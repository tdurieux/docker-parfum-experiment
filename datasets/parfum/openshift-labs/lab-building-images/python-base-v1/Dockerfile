FROM common-base:v1

USER root

RUN HOME=/root && \
    dnf install -y --setopt=tsflags=nodocs glibc-langpack-en \
      redhat-rpm-config gcc python3-devel python3-pip httpd-devel && \
    dnf clean -y --enablerepo='*' all

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

USER 1001
