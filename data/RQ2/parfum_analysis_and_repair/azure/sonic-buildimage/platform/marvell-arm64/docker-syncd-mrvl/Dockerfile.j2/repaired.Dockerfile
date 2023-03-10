{% from "dockers/dockerfile-macros.j2" import install_debian_packages %}
FROM docker-config-engine-buster-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name

RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

COPY \
{% for deb in docker_syncd_mrvl_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

RUN apt-get update \
 && apt-get -y --no-install-recommends install \
    net-tools \
    iputils-ping && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install libpcap-dev libxml2-dev python-dev swig libsensors4-dev nfs-common && rm -rf /var/lib/apt/lists/*;

RUN dpkg -i \
{% for deb in docker_syncd_mrvl_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor %}

COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]
COPY ["files/supervisor-proc-exit-listener", "/usr/bin/"]
COPY ["critical_processes", "/etc/supervisor/"]

## Clean up
RUN apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y
RUN rm -rf /debs

ENTRYPOINT ["/usr/local/bin/supervisord"]
