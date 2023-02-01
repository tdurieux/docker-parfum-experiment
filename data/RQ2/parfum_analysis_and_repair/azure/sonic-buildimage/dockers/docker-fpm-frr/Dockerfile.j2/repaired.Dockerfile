{% from "dockers/dockerfile-macros.j2" import install_debian_packages, install_python_wheels, copy_files %}
FROM docker-swss-layer-buster-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name
ARG frr_user_uid
ARG frr_user_gid

RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

# Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Update apt's cache of available packages
# Install required packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        libc-ares2 \
        iproute2 \
        libjson-c3 \
        logrotate \
        libunwind8 && rm -rf /var/lib/apt/lists/*;

RUN groupadd -g ${frr_user_gid} frr
RUN useradd -u ${frr_user_uid} -g ${frr_user_gid} -M -s /bin/false frr

{% if docker_fpm_frr_debs.strip() -%}
# Copy locally-built Debian package dependencies
{{ copy_files("debs/", docker_fpm_frr_debs.split(' '), "/debs/") }}

# Install locally-built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_fpm_frr_debs.split(' ')) }}
{%- endif %}

{% if docker_fpm_frr_whls.strip() %}
# Copy locally-built Python wheel dependencies
{{ copy_files("python-wheels/", docker_fpm_frr_whls.split(' '), "/python-wheels/") }}

# Install locally-built Python wheel dependencies
{{ install_python_wheels(docker_fpm_frr_whls.split(' ')) }}
{% endif %}

RUN chown -R ${frr_user_uid}:${frr_user_gid} /etc/frr/

# Clean up
RUN apt-get clean -y      && \
    apt-get autoclean -y  && \
    apt-get autoremove -y && \
    rm -rf /debs ~/.cache /python-wheels

COPY ["frr", "/usr/share/sonic/templates"]
COPY ["docker_init.sh", "/usr/bin/"]
COPY ["snmp.conf", "/etc/snmp/frr.conf"]
COPY ["TSA", "/usr/bin/TSA"]
COPY ["TSB", "/usr/bin/TSB"]
COPY ["TSC", "/usr/bin/TSC"]
COPY ["TS", "/usr/bin/TS"]
COPY ["files/supervisor-proc-exit-listener", "/usr/bin"]
COPY ["zsocket.sh", "/usr/bin/"]
RUN chmod a+x /usr/bin/TSA && \
    chmod a+x /usr/bin/TSB && \
    chmod a+x /usr/bin/TSC && \
    chmod a+x /usr/bin/zsocket.sh

ENTRYPOINT ["/usr/bin/docker_init.sh"]
