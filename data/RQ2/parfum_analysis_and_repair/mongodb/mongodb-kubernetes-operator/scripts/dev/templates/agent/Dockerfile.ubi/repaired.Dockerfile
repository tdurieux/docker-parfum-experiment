{% extends "Dockerfile.template" %}

{% set base_image = "registry.access.redhat.com/ubi8/ubi-minimal" %}

{% block packages -%}
RUN microdnf install -y  --disableplugin=subscription-manager curl \
    hostname nss_wrapper tar gzip procps\
    && microdnf upgrade -y  \
    && rm -rf /var/lib/apt/lists/*

RUN microdnf remove perl-IO-Socket-SSL
{% endblock -%}