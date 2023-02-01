FROM docker-config-engine-buster-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name
RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y g++ python3-dev libxml2 libcurl3-gnutls libcjson-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir connexion==2.7.0 \
                 setuptools==21.0.0 \
                 grpcio-tools==1.20.0 \
                 certifi==2017.4.17 \
                 python-dateutil==2.6.0 \
                 six==1.11.0 \
                 urllib3==1.26.5

COPY \
{% for deb in docker_sonic_mgmt_framework_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

RUN dpkg -i \
{% for deb in docker_sonic_mgmt_framework_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor %}

COPY ["start.sh", "rest-server.sh", "/usr/bin/"]
COPY ["mgmt_vars.j2", "/usr/share/sonic/templates/"]
COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]

RUN apt-get remove -y g++ python3-dev
RUN apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y
RUN rm -rf /debs ~/.cache

ENTRYPOINT ["/usr/local/bin/supervisord"]
