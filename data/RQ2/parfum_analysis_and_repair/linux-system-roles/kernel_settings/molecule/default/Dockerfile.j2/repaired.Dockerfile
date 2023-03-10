# SPDX-License-Identifier: MIT
# Molecule managed

{% if item.registry is defined %}
FROM {{ item.registry.url }}/{{ item.image }}
{% else %}
FROM {{ item.image }}
{% endif %}

RUN set -euo pipefail; \
    pkgs="python sudo yum-plugin-ovl bash"; \
    if grep 'CentOS release 6' /etc/centos-release > /dev/null 2>&1; then \
      for file in /etc/yum.repos.d/CentOS-*.repo; do \
        if ! grep '^baseurl=.*vault[.]centos[.]org' "$file"; then \
          sed -i -e 's,^mirrorlist,#mirrorlist,' \
              -e 's,^#baseurl=,baseurl=,' \
              -e 's,mirror.centos.org/centos/$releasever,vault.centos.org/6.10,' \
              "$file"; \
        fi; \
      done; \
      pkgs="$pkgs upstart chkconfig initscripts"; \
    fi; \
    if [ $(command -v apt-get) ]; then \
    apt-get update && apt-get install --no-install-recommends -y python sudo bash ca-certificates && apt-get clean; rm -rf /var/lib/apt/lists/*; \
    elif [ $(command -v dnf) ];then dnf makecache && dnf --assumeyes install python3 sudo python3-devel python3-dnf bash && dnf clean all; \
    elif [ $(command -v yum) ]; then \
    yum makecache fast && yum install -y $pkgs && sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf && yum clean all; rm -rf /var/cache/yum \
    elif [ $(command -v zypper) ]; then zypper refresh && zypper install -y python sudo bash python-xml && zypper clean -a; \
    elif [ $(command -v apk) ]; then apk update && apk add --no-cache python sudo bash ca-certificates; \
    elif [ $(command -v xbps-install) ]; then xbps-install -Syu && xbps-install -y python sudo bash ca-certificates && xbps-remove -O; fi
