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
# Add systemd-sysv package for Debian to get systemd working (and procps for sysctl) and netbase for firewalld
RUN if [ $(command -v apt-get) ]; then \
 apt-get update && apt-get install --no-install-recommends -y python sudo bash ca-certificates iproute2 systemd-sysv procps netbase && apt-get clean; rm -rf /var/lib/apt/lists/*; \
    elif [ $(command -v dnf) ] && grep -q 'platform:el8' /etc/os-release ;then dnf makecache && dnf update -y && dnf --assumeyes install python3 sudo python3-devel bash && sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf && rm -Rf /usr/share/doc && rm -Rf /usr/share/man && dnf clean all && cp /bin/true /sbin/agetty; \
    elif [ $(command -v dnf) ];then dnf makecache && dnf --assumeyes install python sudo python-devel python*-dnf bash iproute && dnf clean all; \
    elif [ $(command -v yum) ]; then \
    yum makecache fast && yum install -y python sudo yum-plugin-ovl bash iproute && sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf && yum clean all; rm -rf /var/cache/yum \
    elif [ $(command -v zypper) ]; then zypper refresh && zypper install -y python sudo bash python-xml iproute2 && zypper clean -a; \
    elif [ $(command -v apk) ]; then apk update && apk add --no-cache python sudo bash ca-certificates; \
    elif [ $(command -v xbps-install) ]; then xbps-install -Syu && xbps-install -y python sudo bash ca-certificates iproute2 && xbps-remove -O; fi