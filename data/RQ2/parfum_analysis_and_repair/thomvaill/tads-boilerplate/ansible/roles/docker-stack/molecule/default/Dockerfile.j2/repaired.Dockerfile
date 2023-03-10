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
        python-pip \
        apt-transport-https curl software-properties-common gnupg-agent \
	" \
    && apt-get update && apt-get install -y --no-install-recommends $runDeps && rm -rf /var/lib/apt/lists/*

# Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update && apt-get install -y --no-install-recommends docker-ce && rm -rf /var/lib/apt/lists/*

# Docker does not support AUFS over AUFS (Docker-in-Docker)
RUN mkdir -p /etc/docker \
    && echo '{"storage-driver": "vfs"}' > /etc/docker/daemon.json

# Ansible docker_stack module dependencies
RUN pip install --no-cache-dir --upgrade setuptools \
    && pip install --no-cache-dir jsondiff pyyaml docker

CMD /usr/bin/dockerd
