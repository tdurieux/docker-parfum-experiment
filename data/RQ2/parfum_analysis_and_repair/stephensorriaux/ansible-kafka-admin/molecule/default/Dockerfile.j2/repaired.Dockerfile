# Molecule managed

{% if item.registry is defined %}
FROM {{ item.registry.url }}/{{ item.image }}
{% else %}
FROM {{ item.image }}
{% endif %}

RUN if [ $(command -v apt-get) ]; then \
 apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y python sudo bash ca-certificates iproute2 && apt-get clean; rm -rf /var/lib/apt/lists/*; \
    elif [ $(command -v dnf) ];then dnf makecache && dnf --assumeyes install python sudo python-devel python2-dnf bash iproute2 && dnf clean all; \
    elif [ $(command -v yum) ]; then \
    yum makecache fast && yum update -y && yum install -y python sudo yum-plugin-ovl bash iproute2 && sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf && yum clean all; rm -rf /var/cache/yum \
    elif [ $(command -v zypper) ]; then zypper refresh && zypper update -y && zypper install -y python sudo bash python-xml iproute2 && zypper clean -a; \
    elif [ $(command -v apk) ]; then apk update && apk add --no-cache python2 sudo bash ca-certificates iproute2; fi
