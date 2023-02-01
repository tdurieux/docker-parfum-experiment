FROM docker-config-engine-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name
RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

## Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

COPY ["sonic-dev.gpg.key", "/etc/apt/"]
RUN apt-key add /etc/apt/sonic-dev.gpg.key
RUN echo "deb http://packages.microsoft.com/repos/sonic-dev/ jessie main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y net-tools \
                       arping \
                       ethtool \
                       tcpdump \
                       ifupdown \
                       jq \
                       bridge-utils \
                       python-ply \
                       libqt5core5a \
                       libqt5network5 \
                       libboost-program-options1.55.0 \
                       libboost-system1.55.0 \
                       libboost-thread1.55.0 \
                       libgmp10 \
                       libjudydebian1 \
                       libnanomsg0 \
                       libdaemon0 \
                       libjansson4 \
                       libatomic1 \
                       libjemalloc1 \
                       liblua5.1-0 \
                       lua-bitop \
                       lua-cjson \
                       openssh-client \
                       openssh-server \
                       libc-ares2 \
                       iproute \
                       libpython2.7 \
                       grub2-common \
                       bash-completion \
                       libelf1 \
                       libmnl0 \


                       build-essential \
                       python-dev \
                       python3-dev \
                       libssl-dev \
                       swig \

                       openssl && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir py2_ipaddress

COPY \
{% for deb in docker_sonic_p4_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor -%}
debs/

RUN dpkg -i \
{% for deb in docker_sonic_p4_debs.split(' ') -%}
debs/{{ deb }}{{' '}}
{%- endfor %}

## Clean up
RUN apt-get purge -y build-essential libssl-dev swig
RUN apt-get purge -y python-dev python3-dev
RUN apt-get clean -y; apt-get autoclean -y; apt-get autoremove -y
RUN rm -rf /debs

RUN sed -ri 's/^(save .*$)/# \1/g;                                                      \
             s/^daemonize yes$/daemonize no/;                                           \
             s/^logfile .*$/logfile ""/;                                                \
             s/^# syslog-enabled no$/syslog-enabled no/;                                \
             s/^# unixsocket/unixsocket/;                                               \
             s/notify-keyspace-events ""/notify-keyspace-events AKE/;                   \
             s/^client-output-buffer-limit pubsub [0-9]+mb [0-9]+mb [0-9]+/client-output-buffer-limit pubsub 0 0 0/ \
            ' /etc/redis/redis.conf

ADD port_config.ini /port_config.ini
COPY ["start.sh", "orchagent.sh", "config_bm.sh", "/usr/bin/"]
COPY ["supervisord.conf", "/etc/supervisor/conf.d/"]
COPY ["files/configdb-load.sh", "/usr/bin/"]
COPY ["files/arp_update", "/usr/bin"]
COPY ["files/arp_update_vars.j2", "/usr/share/sonic/templates/"]
RUN echo "docker-sonic-p4" > /etc/hostname
RUN touch /etc/quagga/zebra.conf

ENTRYPOINT ["/bin/bash"]
