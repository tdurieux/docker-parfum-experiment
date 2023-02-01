{% from "dockers/dockerfile-macros.j2" import install_debian_packages, install_python_wheels, copy_files %}
FROM docker-swss-layer-bullseye-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name
RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

# Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -f -y \
        ifupdown \
        arping \
        iproute2 \
        ndisc6 \
        tcpdump \
        libelf1 \
        libmnl0 \
        bridge-utils \
        conntrack \
        ndppd \
        pciutils \

        build-essential \
        python3-dev && rm -rf /var/lib/apt/lists/*;

{% if ( CONFIGURED_ARCH == "armhf" or CONFIGURED_ARCH == "arm64" ) %}
# Fix for gcc/python/iputils-ping not found in arm docker
RUN apt-get install --no-install-recommends -y \
        gcc \
        iputils-ping && rm -rf /var/lib/apt/lists/*;
{% endif %}

# Dependencies of restore_neighbors.py
RUN pip3 install --no-cache-dir \
         pyroute2==0.5.14 \
         netifaces==0.10.9

{% if ( CONFIGURED_ARCH == "armhf" or CONFIGURED_ARCH == "arm64" ) %}
# Remove installed gcc
RUN apt-get remove -y gcc
{% endif %}

{% if docker_orchagent_debs.strip() -%}
# Copy locally-built Debian package dependencies
{{ copy_files("debs/", docker_orchagent_debs.split(' '), "/debs/") }}

# Install locally-built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_orchagent_debs.split(' ')) }}
{%- endif %}

{% if docker_orchagent_whls.strip() -%}
# Copy locally-built Python wheel dependencies
{{ copy_files("python-wheels/", docker_orchagent_whls.split(' '), "/python-wheels/") }}

# Install locally-built Python wheel dependencies
{{ install_python_wheels(docker_orchagent_whls.split(' ')) }}
{% endif %}

# Clean up
RUN apt-get purge -y          \
        build-essential       \
        python3-dev        && \
    apt-get clean -y       && \
    apt-get autoclean -y   && \
    apt-get autoremove -y  && \
    rm -rf /debs ~/.cache

COPY ["files/arp_update", "/usr/bin"]
COPY ["arp_update.conf", "files/arp_update_vars.j2", "/usr/share/sonic/templates/"]
COPY ["ndppd.conf", "/usr/share/sonic/templates/"]
COPY ["enable_counters.py", "tunnel_packet_handler.py", "/usr/bin/"]
COPY ["orchagent.sh", "swssconfig.sh", "buffermgrd.sh", "/usr/bin/"]
COPY ["files/supervisor-proc-exit-listener", "/usr/bin"]

# Copy all Jinja2 template files into the templates folder
COPY ["*.j2", "/usr/share/sonic/templates/"]

RUN sonic-cfggen -a "{\"ENABLE_ASAN\":\"{{ENABLE_ASAN}}\"}" -t /usr/share/sonic/templates/docker-init.j2 > /usr/bin/docker-init.sh
RUN rm -f /usr/share/sonic/templates/docker-init.j2
RUN chmod 755 /usr/bin/docker-init.sh

ENTRYPOINT ["/usr/bin/docker-init.sh"]
