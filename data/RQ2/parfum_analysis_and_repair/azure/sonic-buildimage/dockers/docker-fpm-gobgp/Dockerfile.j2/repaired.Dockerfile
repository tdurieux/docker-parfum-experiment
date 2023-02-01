FROM docker-fpm-quagga-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

COPY \
{% for deb in docker_fpm_gobgp_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

RUN dpkg -i \
{% for deb in docker_fpm_gobgp_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor %}

## Clean up
RUN apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y
RUN rm -rf /debs

COPY ["start.sh", "/usr/bin/"]
COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]
COPY ["*.j2", "/usr/share/sonic/templates/"]
COPY ["daemons", "/etc/quagga/"]
COPY ["files/supervisor-proc-exit-listener", "/usr/bin"]
COPY ["critical_processes", "/etc/supervisor"]

ENTRYPOINT ["/usr/local/bin/supervisord"]