{% from "dockers/dockerfile-macros.j2" import install_debian_packages, install_python_wheels, copy_files %}
FROM docker-base-stretch:-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y \

        build-essential \
        python-dev && rm -rf /var/lib/apt/lists/*;

{%- if CONFIGURED_ARCH == "armhf" or CONFIGURED_ARCH == "arm64" %}
RUN apt-get install --no-install-recommends -y \
        libxslt-dev \
        libz-dev && rm -rf /var/lib/apt/lists/*;
{%- endif %}

{% if docker_config_engine_stretch_debs.strip() %}
# Copy locally-built Debian package dependencies
{{ copy_files("debs/", docker_config_engine_stretch_debs.split(' '), "/debs/") }}

# Install locally-built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_config_engine_stretch_debs.split(' ')) }}
{% endif %}

{% if docker_config_engine_stretch_whls.strip() %}
# Copy locally-built Python wheel dependencies
{{ copy_files("python-wheels/", docker_config_engine_stretch_whls.split(' '), "/python-wheels/") }}

# Install locally-built Python wheel dependencies
{{ install_python_wheels(docker_config_engine_stretch_whls.split(' ')) }}
{% endif %}

# Copy files
COPY ["files/swss_vars.j2", "/usr/share/sonic/templates/"]

## Clean up
RUN apt-get purge -y               \
        build-essential            \
        python-dev              && \
    apt-get clean -y            && \
    apt-get autoclean -y        && \
    apt-get autoremove -y       && \
    rm -rf /debs /python-wheels
