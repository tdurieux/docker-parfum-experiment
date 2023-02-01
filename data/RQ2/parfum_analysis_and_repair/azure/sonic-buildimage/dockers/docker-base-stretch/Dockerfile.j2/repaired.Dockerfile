{% set prefix = DEFAULT_CONTAINER_REGISTRY %}
{% from "dockers/dockerfile-macros.j2" import install_debian_packages, install_python_wheels, copy_files %}
{% if CONFIGURED_ARCH == "armhf" and MULTIARCH_QEMU_ENVIRON == "y" %}
FROM {{ prefix }}multiarch/debian-debootstrap:armhf-stretch
{% elif CONFIGURED_ARCH == "arm64" and MULTIARCH_QEMU_ENVIRON == "y" %}
FROM {{ prefix }}multiarch/debian-debootstrap:arm64-stretch
{% else %}
FROM {{ prefix }}{{DOCKER_BASE_ARCH}}/debian:stretch
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
        python \
        python-pip \
        vim-tiny \

        redis-tools=5:5.0.3-3~bpo9+2 \

        libpython2.7 \
        libdaemon0 \
        libdbus-1-3 \
        libjansson4 \

        iproute2 \
        net-tools \

        jq \

        libzmq5 && rm -rf /var/lib/apt/lists/*;

# Install a newer version of rsyslog from stretch-backports to support -iNONE
RUN apt-get -y --no-install-recommends -t stretch-backports install rsyslog && rm -rf /var/lib/apt/lists/*;

# Install redis-tools

{% if CONFIGURED_ARCH == "armhf" %}
    RUN curl -f -o  redis-tools_6.0.6-1~bpo10+1_armhf.deb "https://sonicstorage.blob.core.windows.net/packages/redis/redis-tools_6.0.6-1_bpo10+1_armhf.deb?sv=2015-04-05&sr=b&sig=67vHAMxsl%2BS3X1KsqhdYhakJkGdg5FKSPgU8kUiw4as%3D&se=2030-10-24T04%3A22%3A40Z&sp=r"
    RUN dpkg -i redis-tools_6.0.6-1~bpo10+1_armhf.deb || apt-get install -f -y
    RUN rm redis-tools_6.0.6-1~bpo10+1_armhf.deb
{% elif CONFIGURED_ARCH == "arm64" %}
    RUN curl -f -o  redis-tools_6.0.6-1~bpo10+1_arm64.deb "https://sonicstorage.blob.core.windows.net/packages/redis/redis-tools_6.0.6-1_bpo10+1_arm64.deb?sv=2015-04-05&sr=b&sig=GbkJV2wWln3hoz27zKi5erdk3NDKrAFrQriA97bcRCY%3D&se=2030-10-24T04%3A22%3A21Z&sp=r"
    RUN dpkg -i redis-tools_6.0.6-1~bpo10+1_arm64.deb || apt-get install -f -y
    RUN rm redis-tools_6.0.6-1~bpo10+1_arm64.deb
{% else %}
    RUN curl -f -o redis-tools_6.0.6-1~bpo10+1_amd64.deb "https://sonicstorage.blob.core.windows.net/packages/redis/redis-tools_6.0.6-1~bpo10+1_amd64.deb?sv=2015-04-05&sr=b&sig=73zbmjkf3pi%2Bn0R8Hy7CWT2EUvOAyzM5aLYJWCLySGM%3D&se=2030-09-06T19%3A44%3A59Z&sp=r"
    RUN dpkg -i redis-tools_6.0.6-1~bpo10+1_amd64.deb || apt-get install -f -y
    RUN rm redis-tools_6.0.6-1~bpo10+1_amd64.deb
{% endif %}

# Some Python packages require setuptools (or pkg_resources, which is supplied by setuptools)
# and some require wheel
RUN pip install --no-cache-dir setuptools==40.8.0
RUN pip install --no-cache-dir wheel

# For templating
RUN pip install --no-cache-dir j2cli

# Install supervisor
RUN pip install --no-cache-dir supervisor >=3.4.0

# Add support for supervisord to handle startup dependencies
RUN pip install --no-cache-dir supervisord-dependent-startup==1.4.0

RUN mkdir -p /etc/supervisor /var/log/supervisor

RUN apt-get -y purge   \
    exim4              \
    exim4-base         \
    exim4-config       \
    exim4-daemon-light

{% if docker_base_stretch_debs.strip() -%}
# Copy locally-built Debian package dependencies
{{ copy_files("debs/", docker_base_stretch_debs.split(' '), "/debs/") }}

# Install built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_base_stretch_debs.split(' ')) }}
{%- endif %}

# Clean up apt
# Remove /var/lib/apt/lists/*, could be obsoleted for derived images
RUN apt-get clean -y                     && \
    apt-get autoclean -y                 && \
    apt-get autoremove -y                && \
    rm -rf /var/lib/apt/lists/* /tmp/*

COPY ["etc/rsyslog.conf", "/etc/rsyslog.conf"]
COPY ["etc/rsyslog.d/*", "/etc/rsyslog.d/"]
COPY ["root/.vimrc", "/root/.vimrc"]

RUN ln /usr/bin/vim.tiny /usr/bin/vim

COPY ["etc/supervisor/supervisord.conf", "/etc/supervisor/"]
