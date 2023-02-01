FROM {{ "ci-common" | image_tag }} AS ci-common

FROM docker-registry.wikimedia.org/stretch:latest

COPY --from=ci-common /utils /utils
COPY --from=ci-common /utils/gitconfig /etc/gitconfig
COPY wikimedia-git.list /etc/apt/sources.list.d/wikimedia-git.list

# Keep the following in sync with ci-stretch
ARG DEBIAN_FRONTEND=noninteractive

# We run tests in CI as 'nobody' (with unwritable /nonexistent as HOME)
# Set the XDG vars that typically default to HOME, elsewhere to
# avoid broken tools. These are honored by multiple softwares.
# https://phabricator.wikimedia.org/T212602
# https://phabricator.wikimedia.org/T213014
# https://phabricator.wikimedia.org/T220948
ENV XDG_CACHE_HOME=/cache
ENV XDG_CONFIG_HOME=/tmp/xdg-config-home

# backports.list is removed until parent image drops it:
# - https://gerrit.wikimedia.org/r/610050
RUN rm -f /etc/apt/sources.list.d/backports.list \
    && {{ "ca-certificates git" | apt_install }} \
    && install --directory --mode 777 "${XDG_CACHE_HOME}" "${XDG_CONFIG_HOME}" /log /src