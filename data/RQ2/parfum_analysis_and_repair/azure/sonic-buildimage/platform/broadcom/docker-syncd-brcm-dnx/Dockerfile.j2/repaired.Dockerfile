{% from "dockers/dockerfile-macros.j2" import install_debian_packages %}
FROM docker-config-engine-bullseye-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name

RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

COPY \
{% for deb in docker_syncd_brcm_dnx_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

# Install locally-built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_syncd_brcm_dnx_debs.split(' ')) }}

## TODO: add kmod into Depends
RUN apt-get install --no-install-recommends -yf kmod && rm -rf /var/lib/apt/lists/*;

## BRCM uses ethtool to set host interface speed
RUN apt-get install --no-install-recommends -y ethtool && rm -rf /var/lib/apt/lists/*;

COPY ["files/dsserve", "files/bcmcmd", "start.sh", "start_led.sh", "bcmsh", "/usr/bin/"]
RUN chmod +x /usr/bin/dsserve /usr/bin/bcmcmd

COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]
COPY ["files/supervisor-proc-exit-listener", "/usr/bin"]
COPY ["critical_processes", "/etc/supervisor/"]

## Clean up
RUN apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y
RUN rm -rf /debs

ENTRYPOINT ["/usr/local/bin/supervisord"]
