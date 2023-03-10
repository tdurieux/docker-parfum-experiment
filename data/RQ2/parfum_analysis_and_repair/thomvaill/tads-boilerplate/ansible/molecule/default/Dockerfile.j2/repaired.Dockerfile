# Molecule managed

{% if item.registry is defined %}
FROM {{ item.registry.url }}/{{ item.image }}
{% else %}
FROM {{ item.image }}
{% endif %}

{% if item.env is defined %}
{% for var, value in item.env.items() %}
{% if value %}
ENV {{ var }} {{ value }}
{% endif %}
{% endfor %}
{% endif %}

# Dependencies
RUN runDeps=" \
		python sudo bash ca-certificates iproute2 \
	" \
    && apt-get update && apt-get install -y --no-install-recommends $runDeps && rm -rf /var/lib/apt/lists/*

# Docker does not support AUFS over AUFS (Docker-in-Docker)