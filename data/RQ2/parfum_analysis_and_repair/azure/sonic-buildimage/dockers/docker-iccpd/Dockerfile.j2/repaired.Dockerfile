{% from "dockers/dockerfile-macros.j2" import install_debian_packages, install_python_wheels, copy_files %}
FROM docker-config-engine-buster-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name
RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y ebtables && rm -rf /var/lib/apt/lists/*;

COPY \
{% for deb in docker_iccpd_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

RUN dpkg -i \
{% for deb in docker_iccpd_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor %}

COPY ["start.sh", "iccpd.sh", "/usr/bin/"]
COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]
COPY ["iccpd.j2", "/usr/share/sonic/templates/"]

RUN chmod +x /usr/bin/start.sh /usr/bin/iccpd.sh
RUN apt-get clean -y      && \
    apt-get autoclean -y  && \
    apt-get autoremove -y && \
    rm -rf /debs

ENTRYPOINT ["/usr/local/bin/supervisord"]
