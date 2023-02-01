{% set prefix = DEFAULT_CONTAINER_REGISTRY %}
{% if CONFIGURED_ARCH == "armhf" and MULTIARCH_QEMU_ENVIRON == "y" %}
FROM {{ prefix }}multiarch/debian-debootstrap:armhf-jessie
{% elif CONFIGURED_ARCH == "arm64" and MULTIARCH_QEMU_ENVIRON == "y" %}
FROM {{ prefix }}multiarch/debian-debootstrap:arm64-jessie
{% else %}
FROM {{ prefix }}{{DOCKER_BASE_ARCH}}/debian:jessie
{% endif %}

## Remove retired jessie-updates repo
RUN sed -i '/http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list

# Clean documentation in FROM image
RUN find /usr/share/doc -depth \( -type f -o -type l \) ! -name copyright | xargs rm || true

# Clean doc directories that are empty or only contain empty directories
RUN while [ -n "$(find /usr/share/doc -depth -type d -empty -print -exec rmdir {} +)" ]; do :; done
RUN rm -rf               \
    /usr/share/man/*     \
    /usr/share/groff/*   \
    /usr/share/info/*    \
    /usr/share/lintian/* \
    /usr/share/linda/*   \
    /var/cache/man/*     \
    /usr/share/locale/*

# Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Configure data sources for apt/dpkg
COPY ["dpkg_01_drop", "/etc/dpkg/dpkg.cfg.d/01_drop"]
{% if CONFIGURED_ARCH == "armhf" %}
COPY ["sources.list.armhf", "/etc/apt/sources.list"]
{% elif CONFIGURED_ARCH == "arm64" %}
COPY ["sources.list.arm64", "/etc/apt/sources.list"]
COPY ["no-check-valid-until", "/etc/apt/apt.conf.d"]
{% else %}
COPY ["sources.list", "/etc/apt/sources.list"]
{% endif %}
COPY ["no_install_recommend_suggest", "/etc/apt/apt.conf.d"]
RUN apt-get update

# Pre-install fundamental packages
RUN apt-get -y --no-install-recommends install \
    vim-tiny \
    perl \
    python \
    python-pip \
    rsyslog \
    less && rm -rf /var/lib/apt/lists/*;

COPY ["etc/rsyslog.conf", "/etc/rsyslog.conf"]
COPY ["etc/rsyslog.d/*", "/etc/rsyslog.d/"]
COPY ["root/.vimrc", "/root/.vimrc"]

RUN pip install --no-cache-dir --upgrade 'pip<21'
RUN apt-get purge -y python-pip

# Some Python packages require setuptools (or pkg_resources, which is supplied by setuptools)
# and some require wheel
RUN pip install --no-cache-dir setuptools==40.8.0
RUN pip install --no-cache-dir wheel

# Install supervisor
RUN pip install --no-cache-dir supervisor >=3.4.0

RUN mkdir -p /etc/supervisor
RUN mkdir -p /var/log/supervisor

COPY ["etc/supervisor/supervisord.conf", "/etc/supervisor/"]

RUN apt-get -y purge   \
    exim4              \
    exim4-base         \
    exim4-config       \
    exim4-daemon-light

{% if docker_base_debs.strip() -%}
# Copy built Debian packages
{%- for deb in docker_base_debs.split(' ') %}
COPY debs/{{ deb }} debs/
{%- endfor %}

# Install built Debian packages and implicitly install their dependencies
{%- for deb in docker_base_debs.split(' ') %}
RUN dpkg_apt() { [ -f $1 ] && { dpkg -i $1 || apt-get -y install -f; } || return 1; }; dpkg_apt debs/{{ deb }}
{%- endfor %}
{%- endif %}

{% if docker_base_dbgs.strip() -%}
# Install common debug-packages
{%- for dbg_pkg in docker_base_dbgs.split(' ') %}
RUN apt-get -y --no-install-recommends install {{ dbg_pkg }} && rm -rf /var/lib/apt/lists/*;
{%- endfor %}
{% else %}
RUN ln /usr/bin/vim.tiny /usr/bin/vim
{%- endif %}

# Remove python3.4
# Note: if later python3 is required by more docker images, consider install homebrew python3 here instead of in SNMP image only
RUN apt-get purge -y libpython3.4-minimal

# Clean up apt
# Remove /var/lib/apt/lists/*, could be obsoleted for derived images
RUN apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*

RUN rm -rf /tmp/*
