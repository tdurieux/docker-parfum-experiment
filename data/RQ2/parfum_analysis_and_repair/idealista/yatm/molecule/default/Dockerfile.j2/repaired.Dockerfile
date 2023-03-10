# Molecule managed

{% if item.registry is defined %}
FROM {{ item.registry.url }}/{{ item.image }}
{% else %}
FROM {{ item.image }}
{% endif %}

RUN if [ $(command -v apt-get) ]; then \
 apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y python sudo bash ca-certificates systemd systemd-sysv && apt-get clean; rm -rf /var/lib/apt/lists/*; fi