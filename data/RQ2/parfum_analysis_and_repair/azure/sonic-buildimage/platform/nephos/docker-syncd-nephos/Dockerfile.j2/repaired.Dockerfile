FROM docker-config-engine-stretch-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name

RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y libxml2 && rm -rf /var/lib/apt/lists/*; COPY \
{% for deb in docker_syncd_nephos_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

COPY \
{% for deb in docker_syncd_nephos_pydebs.split(' ') -%}
python-debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/



RUN dpkg -i \
{% for deb in docker_syncd_nephos_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor %}

##RUN dpkg -i \
##{% for deb in docker_syncd_nephos_pydebs.split(' ') -%}
##debs/{{ deb }}{{' '}}
##{%- endfor %}

COPY ["files/dsserve", "files/npx_diag", "/usr/bin/"]
RUN chmod +x /usr/bin/npx_diag /usr/bin/dsserve

COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]
COPY ["files/supervisor-proc-exit-listener", "/usr/bin"]
COPY ["critical_processes", "/etc/supervisor/"]

## Clean up
RUN apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y
RUN rm -rf /debs

ENTRYPOINT ["/usr/local/bin/supervisord"]
