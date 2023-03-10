# This Dockerfile was generated from templates/Dockerfile.j2
{% set beat_home = '/usr/share/%s' % beat -%}
{% set binary_file = '%s/%s' % (beat_home, beat) -%}

FROM centos:7

RUN yum update -y && yum install -y curl && yum clean all && rm -rf /var/cache/yum

RUN curl -f -Lso - {{ url }} | \
      tar zxf - -C /tmp && \
    mv /tmp/{{ beat }}-{{ elastic_version }}-linux-x86_64 {{ beat_home }}


ENV ELASTIC_CONTAINER true
ENV PATH={{ beat_home }}:$PATH

COPY config {{ beat_home }}

# Add entrypoint wrapper script
ADD docker-entrypoint /usr/local/bin

# Provide a non-root user.
RUN groupadd --gid 1000 {{ beat }} && \
    useradd -M --uid 1000 --gid 1000 --home {{ beat_home }} {{ beat }}

WORKDIR {{ beat_home }}
RUN mkdir data logs && \
    chown -R root:{{ beat }} . && \
    find {{ beat_home }} -type d -exec chmod 0750 {} \; && \
    find {{ beat_home }} -type f -exec chmod 0640 {} \; && \
    chmod 0750 {{ binary_file }} && \
    {%- if beat == 'filebeat' or beat == 'metricbeat' -%}
    chmod 0770 modules.d && \
    {% endif -%}
    chmod 0770 data logs

{%- if beat == 'packetbeat' %}
RUN setcap cap_net_raw,cap_net_admin=eip {{ binary_file }}
{% endif %}
{%- if beat == 'heartbeat' %}
RUN setcap cap_net_raw=eip {{ binary_file }}
{% endif %}
{%- if beat == 'auditbeat' %}
USER root
{% else %}
USER 1000
{% endif %}

LABEL org.label-schema.schema-version="1.0" \
  org.label-schema.vendor="Elastic" \
  org.label-schema.name="{{ beat }}" \
  org.label-schema.version="{{ elastic_version }}" \
  org.label-schema.url="https://www.elastic.co/products/beats/{{ beat }}" \
  org.label-schema.vcs-url="https://github.com/elastic/beats-docker" \
{% if image_flavor == 'oss' -%}
  license="Apache-2.0"
{% else -%}
  license="Elastic License"
{% endif -%}

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
CMD ["-e"]
