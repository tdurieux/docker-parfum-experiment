{% from "dockers/dockerfile-macros.j2" import install_debian_packages, install_python_wheels, copy_files %}
FROM docker-config-engine-buster-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

# Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

{% if docker_sonic_sdk_debs.strip() -%}
# Copy locally-built Debian package dependencies
{{ copy_files("debs/", docker_sonic_sdk_debs.split(' '), "/debs/") }}

# Install locally-built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_sonic_sdk_debs.split(' ')) }}
{%- endif %}

{% if docker_sonic_sdk_whls.strip() %}
# Copy locally-built Python wheel dependencies
{{ copy_files("python-wheels/", docker_sonic_sdk_whls.split(' '), "/python-wheels/") }}

# Install locally-built Python wheel dependencies
{{ install_python_wheels(docker_sonic_sdk_whls.split(' ')) }}
{% endif %}

# Clean up
RUN apt-get clean -y       && \
    apt-get autoclean -y   && \
    apt-get autoremove -y  && \
    rm -rf /debs /python-wheels/