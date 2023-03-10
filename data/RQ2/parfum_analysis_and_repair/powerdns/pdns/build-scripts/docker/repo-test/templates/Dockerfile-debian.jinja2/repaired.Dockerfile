FROM {{ os_image }}:{{ os_version }}

RUN apt-get update && apt-get install --no-install-recommends -y curl gnupg dnsutils apt-transport-https && rm -rf /var/lib/apt/lists/*;

{% if release.startswith('dnsdist-') %}
COPY pkg-pin /etc/apt/preferences.d/dnsdist
{% else %}
COPY pkg-pin /etc/apt/preferences.d/pdns
{% endif %}

COPY pdns.list.{{ release }}.{{ os }}-{{ os_version }} /etc/apt/sources.list.d/pdns.list

RUN curl -f https://repo.powerdns.com/CBC8B383-pub.asc -o /etc/apt/trusted.gpg.d/CBC8B383-pub.asc \
         https://repo.powerdns.com/FD380FBB-pub.asc -o /etc/apt/trusted.gpg.d/FD380FBB-pub.asc
RUN apt-get update && apt-get install --no-install-recommends -y {{ pkg }} && rm -rf /var/lib/apt/lists/*;

{# in the old script this was just for rec-43, -44 and -45 #}
{% if release.startswith('rec-') %}
RUN mkdir /var/run/pdns-recursor
{% endif %}

CMD {{ cmd }} --version

