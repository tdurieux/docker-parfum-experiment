{% from "dockers/dockerfile-macros.j2" import install_debian_packages, install_python_wheels, copy_files %}
FROM docker-config-engine-bullseye-{{DOCKER_USERNAME}}:{{DOCKER_USERTAG}}

ARG docker_container_name
RUN [ -f /etc/rsyslog.conf ] && sed -ri "s/%syslogtag%/$docker_container_name#%syslogtag%/;" /etc/rsyslog.conf

# Make apt-get non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Update apt's cache of available packages
RUN apt-get update && apt-get install --no-install-recommends -y redis-tools redis-server && rm -rf /var/lib/apt/lists/*; # Install redis-server


{% if docker_database_debs.strip() -%}
# Copy locally-built Debian package dependencies
{{ copy_files("debs/", docker_database_debs.split(' '), "/debs/") }}

# Install locally-built Debian packages and implicitly install their dependencies
{{ install_debian_packages(docker_database_debs.split(' ')) }}
{%- endif %}

# Clean up
RUN apt-get clean -y                                  && \
    apt-get autoclean -y                              && \
    apt-get autoremove -y                             && \
    rm -rf /debs ~/.cache                             && \
    sed -ri 's/^(save .*$)/# \1/g;                       \
             s/^daemonize yes$/daemonize no/;            \
             s/^logfile .*$/logfile ""/;                 \
             s/^# syslog-enabled no$/syslog-enabled no/; \
             s/^# unixsocket/unixsocket/;                \
             s/redis-server.sock/redis.sock/g;           \
             s/^client-output-buffer-limit pubsub [0-9]+mb [0-9]+mb [0-9]+/client-output-buffer-limit pubsub 0 0 0/ \
            ' /etc/redis/redis.conf

COPY ["supervisord.conf.j2", "/usr/share/sonic/templates/"]
COPY ["docker-database-init.sh", "/usr/local/bin/"]
COPY ["database_config.json.j2", "/usr/share/sonic/templates/"]
COPY ["database_global.json.j2", "/usr/share/sonic/templates/"]
COPY ["files/supervisor-proc-exit-listener", "/usr/bin"]
COPY ["files/sysctl-net.conf", "/etc/sysctl.d/"]
COPY ["critical_processes", "/etc/supervisor"]
COPY ["files/update_chassisdb_config", "/usr/local/bin/"]
COPY ["flush_unused_database", "/usr/local/bin/"]

ENTRYPOINT ["/usr/local/bin/docker-database-init.sh"]
