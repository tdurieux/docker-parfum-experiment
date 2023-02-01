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

RUN if [ $(command -v apt-get) ]; then \
 apt-get update && apt-get install --no-install-recommends -y openssh-server && apt-get clean; rm -rf /var/lib/apt/lists/*; \
    elif [ $(command -v dnf) ] && cat /etc/os-release | grep -q '^NAME="CentOS Linux"' && \
      cat /etc/os-release | grep -q '^VERSION_ID="8"' ;then dnf makecache && dnf install -y openssh-server && dnf clean all ; \
    elif [ $(command -v yum) ] && cat /etc/os-release | grep -q '^NAME="CentOS Linux"' && \
      cat /etc/os-release | grep -q '^VERSION_ID="7"' ; then \
      yum makecache fast && yum install -y openssh-server && yum clean all ; rm -rf /var/cache/yum \
    fi
