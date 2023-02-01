# To build this Dockerfile:
#
# From the root of configuration:
#
# docker build -f docker/build/forum/Dockerfile .
#
# This allows the dockerfile to update /edx/app/edx_ansible/edx_ansible
# with the currently checked-out configuration repo.

ARG BASE_IMAGE_TAG=latest
FROM edxops/xenial-common:${BASE_IMAGE_TAG}
LABEL maintainer="edxops"

WORKDIR /edx/app/edx_ansible/edx_ansible/docker/plays
ADD . /edx/app/edx_ansible/edx_ansible
COPY docker/build/forum/ansible_overrides.yml /

ARG OPENEDX_RELEASE=master
ENV OPENEDX_RELEASE=${OPENEDX_RELEASE}
RUN /edx/app/edx_ansible/venvs/edx_ansible/bin/ansible-playbook forum.yml \
    -i '127.0.0.1,' -c local \
    -t "install:base,install:configuration,install:app-requirements,install:code" \
    --extra-vars="forum_version=${OPENEDX_RELEASE}" \
    --extra-vars="@/ansible_overrides.yml"
WORKDIR /edx/app
CMD ["/edx/app/supervisor/venvs/supervisor/bin/supervisord", "-n", "--configuration", "/edx/app/supervisor/supervisord.conf"]
EXPOSE 4567
