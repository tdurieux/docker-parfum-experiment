FROM colinmollenhour/mariadb-galera-swarm

RUN apt-get update && apt-get install --no-install-recommends -y dnsutils netcat pv && rm -rf /var/lib/apt/lists/*;

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]