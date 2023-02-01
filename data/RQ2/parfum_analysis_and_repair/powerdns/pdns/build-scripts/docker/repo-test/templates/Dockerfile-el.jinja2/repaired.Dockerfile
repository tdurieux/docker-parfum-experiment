FROM {{ os_image }}:{{ os_version }}

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm bind-utils && rm -rf /var/cache/yum

{% if os_version == '7' %}
RUN yum install -y yum-plugin-priorities && rm -rf /var/cache/yum
{% endif %}

{% if release == 'dnsdist-15' and os_version == '8' %}
RUN dnf install -y 'dnf-command(config-manager)'
RUN dnf config-manager --set-enabled powertools
{% endif %}

RUN curl -f -o /etc/yum.repos.d/powerdns-{{ release }}.repo https://repo.powerdns.com/repo-files/{{ os }}-{{ release }}.repo
RUN yum install --assumeyes {%- if os_version == '8' %} --nobest{% endif %} {{ pkg }} && rm -rf /var/cache/yum

{% if release.startswith('rec-') %}
RUN mkdir /var/run/pdns-recursor
{% endif %}

CMD {{ cmd }} --version

