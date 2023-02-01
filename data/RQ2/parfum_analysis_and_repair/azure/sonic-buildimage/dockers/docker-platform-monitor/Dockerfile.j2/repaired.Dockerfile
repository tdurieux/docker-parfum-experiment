{% from "dockers/dockerfile-macros.j2" import install_debian_packages, install_python_wheels, copy_files %}
FROM docker-config-engine-bullseye-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name
ARG image_version
RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

# Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Pass the image_version to container
ENV IMAGE_VERSION=$image_version

# Install required packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        build-essential \
        python3-dev \
        ipmitool \
        librrd8 \
        librrd-dev \
        rrdtool \
        python3-smbus \
        dmidecode \
        i2c-tools \
        psmisc \
        python3-jsonschema \
        libpci3 && rm -rf /var/lib/apt/lists/*;

# On Arista devices, the sonic_platform wheel is not installed in the container.
# Instead, the installation directory is mounted from the host OS. However, this method
# doesn't ensure all dependencies are installed in the container. So here we
# install any dependencies required by the Arista sonic_platform package.
# TODO: eliminate the need to install these explicitly.
RUN pip3 install --no-cache-dir grpcio==1.39.0 \
        grpcio-tools==1.39.0

# Barefoot platform vendors' sonic_platform packages import the Python 'thrift' library
RUN pip3 install --no-cache-dir thrift==0.13.0

{% if docker_platform_monitor_debs.strip() -%}
# Copy locally-built Debian package dependencies
{{ copy_files("debs/", docker_platform_monitor_debs.split(' '), "/debs/") }}

# Install locally-built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_platform_monitor_debs.split(' ')) }}
{%- endif %}

{% if docker_platform_monitor_pydebs.strip() -%}
# Copy locally-built Debian package dependencies
{{ copy_files("python-debs/", docker_platform_monitor_pydebs.split(' '), "/debs/") }}

# Install locally-built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_platform_monitor_pydebs.split(' ')) }}
{%- endif %}

{% if docker_platform_monitor_whls.strip() -%}
# Copy locally-built Python wheel dependencies
{{ copy_files("python-wheels/", docker_platform_monitor_whls.split(' '), "/python-wheels/") }}

# Install locally-built Python wheel dependencies
{{ install_python_wheels(docker_platform_monitor_whls.split(' ')) }}
{% endif %}


# Clean up
RUN apt-get purge -y           \
        build-essential        \
        python3-dev         && \
    apt-get clean -y        && \
    apt-get autoclean -y    && \
    apt-get autoremove -y   && \
    rm -rf /debs               \
           /python-wheels      \
           ~/.cache

COPY ["lm-sensors.sh", "/usr/bin/"]
COPY ["docker-pmon.supervisord.conf.j2", "docker_init.j2", "/usr/share/sonic/templates/"]
COPY ["ssd_tools/*", "/usr/bin/"]
COPY ["files/supervisor-proc-exit-listener", "/usr/bin"]
COPY ["critical_processes", "/etc/supervisor"]

RUN sonic-cfggen -a "{\"CONFIGURED_PLATFORM\":\"{{CONFIGURED_PLATFORM}}\"}" -t /usr/share/sonic/templates/docker_init.j2 > /usr/bin/docker_init.sh
RUN rm -f /usr/share/sonic/templates/docker_init.j2
RUN chmod 755 /usr/bin/docker_init.sh

ENTRYPOINT ["/usr/bin/docker_init.sh"]
