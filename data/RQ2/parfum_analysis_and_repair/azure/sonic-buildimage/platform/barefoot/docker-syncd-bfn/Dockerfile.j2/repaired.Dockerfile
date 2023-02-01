FROM docker-config-engine-buster-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
        libxml2 \
        libpcap-dev \
        libusb-1.0-0-dev \
        libcurl4 \
        libcurl4-gnutls-dev \
        libunwind8-dev \
        libpython3.4 \
        libc-ares2 \
        libedit2 \
        libgoogle-perftools4 && rm -rf /var/lib/apt/lists/*; COPY \
{% for deb in docker_syncd_bfn_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/













RUN dpkg -i \
{% for deb in docker_syncd_bfn_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor %}

COPY ["start.sh", "/usr/bin/"]
COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]
COPY ["files/supervisor-proc-exit-listener", "/usr/bin"]
COPY ["critical_processes", "/etc/supervisor/"]

## Clean up
RUN apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y
RUN rm -rf /debs

ENTRYPOINT ["/usr/local/bin/supervisord"]
