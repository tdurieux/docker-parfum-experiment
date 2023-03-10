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

RUN \
  if [ $(command -v apt-get) ]; then \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y aptitude bash ca-certificates curl iproute2 python-apt python3 python3-apt procps sudo systemd systemd-sysv vim \
    && apt-get clean; rm -rf /var/lib/apt/lists/*; \
  elif [ $(command -v dnf) ];then \
    dnf makecache \
    && dnf --assumeyes install bash iproute sudo /usr/bin/dnf-3 /usr/bin/python3 /usr/bin/python3-config vim \
    && dnf clean all; \
  elif [ $(command -v yum) ]; then \
    yum makecache fast \
    && yum install -y bash iproute sudo /usr/bin/python /usr/bin/python2-config vim yum-plugin-ovl \
    && sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf \
    && yum clean all; rm -rf /var/cache/yum \
  elif [ $(command -v zypper) ]; then \
    zypper refresh \
    && zypper install -y bash iproute2 python3 sudo vim \
    && zypper clean -a; \
  elif [ $(command -v apk) ]; then \
    apk update \
    && apk add --no-cache bash ca-certificates curl openrc python3 sudo vim; \
    echo 'rc_provide="loopback net"' >> /etc/rc.conf; \
  elif [ $(command -v xbps-install) ]; then \
    xbps-install -Syu \
    && xbps-install -y bash ca-certificates iproute2 python3 sudo vim \
    && xbps-remove -O; \
  fi
