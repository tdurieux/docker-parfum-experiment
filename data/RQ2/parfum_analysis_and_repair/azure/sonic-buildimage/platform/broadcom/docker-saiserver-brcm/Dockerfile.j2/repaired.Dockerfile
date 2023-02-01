{% from "dockers/dockerfile-macros.j2" import install_debian_packages %}
FROM docker-config-engine-bullseye-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name
RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

## Pre-install the fundamental packages
RUN apt-get update \
 && apt-get -y --no-install-recommends install \
    gdb \
    libboost-atomic1.71.0 && rm -rf /var/lib/apt/lists/*;

COPY \
{% for deb in docker_saiserver_brcm_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

# Install locally-built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_saiserver_brcm_debs.split(' ')) }}

## TODO: add kmod into Depends
RUN apt-get install --no-install-recommends -yf kmod && rm -rf /var/lib/apt/lists/*;

COPY ["files/dsserve", "files/bcmcmd", "start.sh", "bcmsh", "/usr/bin/"]
RUN chmod +x /usr/bin/dsserve /usr/bin/bcmcmd

COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]

## Clean up
RUN apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y
RUN rm -rf /debs

ENTRYPOINT ["/usr/local/bin/supervisord"]
