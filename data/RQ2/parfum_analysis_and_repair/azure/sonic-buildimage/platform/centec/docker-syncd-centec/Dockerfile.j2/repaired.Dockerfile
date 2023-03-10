FROM docker-config-engine-buster-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name

RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -yf kmod && rm -rf /var/lib/apt/lists/*; COPY \
{% for deb in docker_syncd_centec_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

RUN dpkg -i \
{% for deb in docker_syncd_centec_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor %}

## TODO: add kmod into Depends


COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]
COPY ["files/supervisor-proc-exit-listener", "/usr/bin/"]
COPY ["critical_processes", "/etc/supervisor/"]

## Clean up
RUN apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y
RUN rm -rf /debs

ENTRYPOINT ["/usr/local/bin/supervisord"]
