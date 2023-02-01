FROM {{ "ci-buster" | image_tag }}

ENV PUPPET_DIR='/srv/workspace/puppet'

{% set pkgs_to_install = """build-essential bundler  rubygems-integration \
rake ruby ruby-dev ca-certificates default-libmysqlclient-dev mtail=3.0.0~rc35-3+wmf3 \
isc-dhcp-server unzip lua-busted file python3-dev python3-pip tox python-dev python-pip \
python3-wheel python-wheel python3-ldap systemd shellcheck"""
%}

ARG PIP_DISABLE_PIP_VERSION_CHECK=1

USER root
COPY apt.pref /etc/apt/preferences.d/pinning.pref
RUN {{ pkgs_to_install | apt_install }} \
    && pip3 install --no-cache-dir setuptools \
    && rm -fR "$XDG_CACHE_HOME/pip" \
    && install --owner=nobody --group=nogroup --directory /srv/workspace

USER nobody
RUN git clone https://gerrit.wikimedia.org/r/operations/puppet "${PUPPET_DIR}" \
    && cd "${PUPPET_DIR}" \
    && git tag -f 'docker-head' && git gc --prune=now \
    && TOX_TESTENV_PASSENV=PY_COLORS PY_COLORS=1 tox -v --notest \
    && bundle install --clean --path="${PUPPET_DIR}/.bundle"

WORKDIR /srv/workspace

ENTRYPOINT ["/run.sh"]

COPY bundle-config "${PUPPET_DIR}/.bundle/bundle-config"
COPY run.sh /run.sh