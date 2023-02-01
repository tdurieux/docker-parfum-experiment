{% set prefix = DEFAULT_CONTAINER_REGISTRY %}
{% from "dockers/dockerfile-macros.j2" import install_debian_packages, install_python_wheels, copy_files %}
{% if CONFIGURED_ARCH == "armhf" and MULTIARCH_QEMU_ENVIRON == "y" %}
FROM {{ prefix }}multiarch/debian-debootstrap:armhf-bullseye
{% elif CONFIGURED_ARCH == "arm64" and MULTIARCH_QEMU_ENVIRON == "y" %}
FROM {{ prefix }}multiarch/debian-debootstrap:arm64-bullseye
{% else %}
FROM {{ prefix }}{{DOCKER_BASE_ARCH}}/debian:bullseye
{% endif %}

# Clean documentation in FROM image
RUN find /usr/share/doc -depth \( -type f -o -type l \) ! -name copyright | xargs rm || true

# Clean doc directories that are empty or only contain empty directories
RUN while [ -n "$(find /usr/share/doc -depth -type d -empty -print -exec rmdir {} +)" ]; do :; done && \
    rm -rf               \
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
{% else %}
COPY ["sources.list", "/etc/apt/sources.list"]
{% endif %}
COPY ["no_install_recommend_suggest", "/etc/apt/apt.conf.d"]
COPY ["no-check-valid-until", "/etc/apt/apt.conf.d"]

# Update apt cache and
# pre-install fundamental packages
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        curl \
        less \
        perl \
        procps \
        python3 \
        python3-distutils \
        python3-pip \
        rsyslog \
        vim-tiny \

        redis-tools \

        libdaemon0 \
        libdbus-1-3 \
        libjansson4 \

        iproute2 \
        net-tools \

        jq \

        libzmq5 \
        libwrap0 && rm -rf /var/lib/apt/lists/*;

# Upgrade pip via PyPI and uninstall the Debian version
RUN pip3 install --no-cache-dir --upgrade pip
RUN apt-get purge -y python3-pip

# setuptools and wheel are necessary for installing some Python wheel packages
RUN pip3 install --no-cache-dir setuptools==49.6.00
RUN pip3 install --no-cache-dir wheel==0.35.1

# For templating
RUN pip3 install --no-cache-dir j2cli

# Install supervisor
RUN pip3 install --no-cache-dir supervisor==4.2.1

# Add support for supervisord to handle startup dependencies
RUN pip3 install --no-cache-dir supervisord-dependent-startup==1.4.0

RUN mkdir -p /etc/supervisor /var/log/supervisor

RUN apt-get -y purge   \
    exim4              \
    exim4-base         \
    exim4-config       \
    exim4-daemon-light

{% if docker_base_bullseye_debs.strip() -%}
# Copy locally-built Debian package dependencies
{{ copy_files("debs/", docker_base_bullseye_debs.split(' '), "/debs/") }}

# Install built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_base_bullseye_debs.split(' ')) }}
{%- endif %}

# Clean up apt
# Remove /var/lib/apt/lists/*, could be obsoleted for derived images
RUN apt-get clean -y                     && \
    apt-get autoclean -y                 && \
    apt-get autoremove -y                && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/.cache

COPY ["etc/rsyslog.conf", "/etc/rsyslog.conf"]
COPY ["etc/rsyslog.d/*", "/etc/rsyslog.d/"]
COPY ["root/.vimrc", "/root/.vimrc"]

RUN ln /usr/bin/vim.tiny /usr/bin/vim

COPY ["etc/supervisor/supervisord.conf", "/etc/supervisor/"]
