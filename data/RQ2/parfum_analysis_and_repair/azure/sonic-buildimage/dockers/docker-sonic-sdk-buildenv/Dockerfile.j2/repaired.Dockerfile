{% from "dockers/dockerfile-macros.j2" import install_debian_packages, install_python_wheels, copy_files %}
FROM sonic-sdk-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG base_os_version
ARG docker_database_version
ARG docker_swss_version
ARG docker_syncd_version
ARG image_version

# Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -f -y \
        build-essential && rm -rf /var/lib/apt/lists/*;

{% if docker_sonic_sdk_buildenv_debs.strip() -%}
# Copy locally-built Debian package dependencies
{{ copy_files("debs/", docker_sonic_sdk_buildenv_debs.split(' '), "/debs/") }}

# Install locally-built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_sonic_sdk_buildenv_debs.split(' ')) }}
{%- endif %}

{% if docker_sonic_sdk_buildenv_whls.strip() %}
# Copy locally-built Python wheel dependencies
{{ copy_files("python-wheels/", docker_sonic_sdk_buildenv_whls.split(' '), "/python-wheels/") }}

# Install locally-built Python wheel dependencies
{{ install_python_wheels(docker_sonic_sdk_buildenv_whls.split(' ')) }}
{% endif %}

# Clean up
RUN apt-get clean -y       && \
    apt-get autoclean -y   && \
    apt-get autoremove -y  && \
    rm -rf /debs /python-wheels/

LABEL com.azure.sonic.sdk.versions.base-os=$base_os_version
LABEL com.azure.sonic.sdk.versions.database=$docker_database_version
LABEL com.azure.sonic.sdk.versions.swss=$docker_swss_version
LABEL com.azure.sonic.sdk.versions.syncd=$docker_syncd_version
LABEL com.azure.sonic.sdk.version.image_hash=$image_version
