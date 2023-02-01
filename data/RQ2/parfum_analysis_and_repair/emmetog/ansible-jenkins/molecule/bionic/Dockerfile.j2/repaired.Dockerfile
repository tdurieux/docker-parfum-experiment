# Molecule managed

{% if item.registry is defined %}
FROM {{ item.registry.url }}/{{ item.image }}
{% else %}
FROM {{ item.image }}
{% endif %}

RUN apt-get update && \
    apt-get install --no-install-recommends -y gpg apt-transport-https aptitude bash ca-certificates sudo \
        python python-apt && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN useradd -G sudo molecule
