# Molecule managed

{% if item.registry is defined %}
FROM {{ item.registry.url }}/{{ item.image }}
{% else %}
FROM {{ item.image }}
{% endif %}

RUN if [ $(command -v apt-get) ]; then \
 apt-get update && apt-get install --no-install-recommends -y python sudo bash ca-certificates && apt-get clean; rm -rf /var/lib/apt/lists/*; \
    elif [ $(command -v dnf) ];then dnf makecache && dnf --assumeyes install python sudo python-devel python2-dnf bash && dnf clean all; \
    elif [ $(command -v yum) ]; then \
    yum makecache fast && yum install -y python sudo yum-plugin-ovl bash && sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf && yum clean all; rm -rf /var/cache/yum \
    elif [ $(command -v zypper) ]; then zypper refresh && zypper install -y python sudo bash python-xml && zypper clean -a; \
    elif [ $(command -v apk) ]; then apk update && apk add --no-cache python sudo bash ca-certificates; \
    elif [ $(command -v xbps-install) ]; then xbps-install -Syu && xbps-install -y python sudo bash ca-certificates && xbps-remove -O; fi

{% if 'ubuntu' in item.image or 'debian' in item.image %}
RUN apt-get update
RUN apt-get install --no-install-recommends -y dbus dbus-user-session && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
{% endif %}

{% if 'ubuntu1804' in item.image %}
RUN apt-get install --no-install-recommends -y dirmngr && rm -rf /var/lib/apt/lists/*;
{% endif %}

{% if 'debian9' in item.image %}
RUN apt-get install --no-install-recommends -y gnupg2 && rm -rf /var/lib/apt/lists/*;
{% endif %}
