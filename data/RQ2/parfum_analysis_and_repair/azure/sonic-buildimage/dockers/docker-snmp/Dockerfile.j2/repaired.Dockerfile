{% from "dockers/dockerfile-macros.j2" import install_debian_packages, install_python3_wheels, copy_files %}
FROM docker-config-engine-buster-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name
ARG image_version
RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

# Enable -O for all Python calls
ENV PYTHONOPTIMIZE 1

# Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Pass the image_version to container
ENV IMAGE_VERSION=$image_version

# Update apt's cache of available packages
# Install make/gcc which is required for installing hiredis
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        python3-dev \
        gcc \
        make \
        ipmitool && rm -rf /var/lib/apt/lists/*;

{% if docker_snmp_debs.strip() -%}
# Copy locally-built Debian package dependencies
{{ copy_files("debs/", docker_snmp_debs.split(' '), "/debs/") }}

# Install locally-built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_snmp_debs.split(' ')) }}
{%- endif %}

# Fix for hiredis compilation issues for ARM
# python will throw for missing locale
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen "en_US.UTF-8"
RUN dpkg-reconfigure --frontend noninteractive locales
ENV LC_CTYPE=en_US.UTF-8
RUN sed -i '/^#.* en_US.* /s/^#//' /etc/locale.gen
RUN locale-gen

# Install dependencies used by some plugins
RUN pip3 install --no-cache-dir \
        hiredis                             \
        pyyaml                              \
        smbus

{% if docker_snmp_whls.strip() -%}
# Copy locally-built Python wheel dependencies
{{ copy_files("python-wheels/", docker_snmp_whls.split(' '), "/python-wheels/") }}

# Install locally-built Python wheel dependencies
{{ install_python3_wheels(docker_snmp_whls.split(' ')) }}
{% endif %}

RUN python3 -m sonic_ax_impl install

# Clean up
RUN apt-get -y purge     \
        python3-dev      \
        gcc              \
        make                && \
    apt-get clean -y        && \
    apt-get autoclean -y    && \
    apt-get autoremove -y --purge && \
    find / | grep -E "__pycache__" | xargs rm -rf && \
    rm -rf /debs /python-wheels ~/.cache

COPY ["start.sh", "/usr/bin/"]
COPY ["snmp_yml_to_configdb.py", "/usr/bin/"]
COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]
COPY ["*.j2", "/usr/share/sonic/templates/"]
COPY ["files/supervisor-proc-exit-listener", "/usr/bin"]
COPY ["critical_processes", "/etc/supervisor"]

# Although exposing ports is not needed for host net mode, keep it for possible bridge mode
EXPOSE 161/udp 162/udp

ENTRYPOINT ["/usr/local/bin/supervisord"]
