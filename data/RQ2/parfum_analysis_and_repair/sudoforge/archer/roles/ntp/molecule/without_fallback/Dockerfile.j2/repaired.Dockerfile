{% if item.registry is defined %}
FROM {{ item.registry.url }}/{{ item.image }}
{% else %}
FROM {{ item.image }}
{% endif %}

RUN pacman -Sy --noconfirm python2 sudo && \
    ln -sf /usr/bin/python2 /usr/bin/python && \
    curl -f -Lo /usr/local/bin/goss "https://github.com/aelsabbahy/goss/releases/download/v0.3.6/goss-linux-amd64" && \
    chmod 0755 /usr/local/bin/goss
