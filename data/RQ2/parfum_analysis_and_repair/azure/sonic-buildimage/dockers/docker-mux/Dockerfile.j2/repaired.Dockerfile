{% from "dockers/dockerfile-macros.j2" import install_debian_packages, install_python_wheels, copy_files %}
FROM docker-config-engine-bullseye-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name
RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -f -y \
        libmnl0 && rm -rf /var/lib/apt/lists/*;

{% if docker_mux_debs.strip() -%}
# Copy locally-built Debian package dependencies
{{ copy_files("debs/", docker_mux_debs.split(' '), "/debs/") }}

# Install locally-built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_mux_debs.split(' ')) }}
{%- endif %}

## Clean up
RUN apt-get clean -y        && \
    apt-get autoclean -y    && \
    apt-get autoremove -y   && \
    rm -rf /debs

COPY ["docker-init.sh", "/usr/bin/"]
COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]
COPY ["files/supervisor-proc-exit-listener", "/usr/bin"]
COPY ["critical_processes", "/etc/supervisor/"]

## Copy all Jinja2 template files into the templates folder
COPY ["*.j2", "/usr/share/sonic/templates/"]

ENTRYPOINT ["/usr/bin/docker-init.sh"]
