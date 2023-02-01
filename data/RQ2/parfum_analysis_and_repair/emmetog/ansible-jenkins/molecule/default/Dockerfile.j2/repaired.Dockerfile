# Molecule managed

{% if item.registry is defined %}
FROM {{ item.registry.url }}/{{ item.image }}
{% else %}
FROM {{ item.image }}
{% endif %}

RUN \
    if [ $(command -v apt-get) ]; then \
        apt-get update && \
        apt-get install --no-install-recommends -y apt-transport-https aptitude bash ca-certificates sudo \
            python python-apt && \
        apt-get clean; rm -rf /var/lib/apt/lists/*; \
    elif [ $(command -v yum) ]; then \
        yum makecache fast && \
        yum install -y python sudo yum-plugin-ovl bash && \
        sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf && \
        yum clean all; rm -rf /var/cache/yum \
    fi

RUN useradd -G sudo molecule
