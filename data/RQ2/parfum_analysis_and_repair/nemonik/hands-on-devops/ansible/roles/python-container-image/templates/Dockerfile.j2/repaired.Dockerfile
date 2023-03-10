FROM {{ registry_host }}:{{ registry_port }}/python:{{ python_version }}
MAINTAINER Michael Joseph Walsh <nemonik@gmail.com>

{% if http_proxy %}
ENV http_proxy={{ http_proxy }}
ENV HTTP_PROXY={{ http_proxy }}
{% endif %}
{% if https_proxy %}
ENV https_proxy={{ https_proxy }}
ENV HTTPS_PROXY={{ https_proxy }}
{% endif %}
{% if no_proxy %}
ENV no_proxy={{ no_proxy }}
ENV NO_PROXY={{ no_proxy }}
{% endif %}

{% if CA_CERTIFICATES %}
RUN cd /usr/local/share/ca-certificates/ && {% for ca in CA_CERTIFICATES %} wget {{ ca }} &&{% endfor %} update-ca-certificates
{% endif %}

RUN apt-get update && \
        apt-get install -y --no-install-recommends apt-transport-https && \
        rm -rf /var/lib/apt/lists/* && \
        apt-get clean

RUN pip install --no-cache-dir --upgrade pip
