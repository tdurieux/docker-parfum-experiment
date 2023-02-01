FROM docker-config-engine-stretch-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name

RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

COPY \
{% for deb in docker_syncd_invm_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

# Needed for Innovium Debug Shell
RUN apt-get install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpython2.7 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libjansson4 && rm -rf /var/lib/apt/lists/*;

RUN dpkg -i \
{% for deb in docker_syncd_invm_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor %}

COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]

## Clean up
RUN apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y
RUN rm -rf /debs

ENTRYPOINT ["/usr/local/bin/supervisord"]
