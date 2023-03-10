{% extends "Dockerfile.template" %}

{% set base_image = "ubuntu:20.04" %}

{% block packages -%}
RUN apt-get -qq update \
        && apt-get -y --no-install-recommends -qq install \
        curl \
        libnss-wrapper \
        && apt-get upgrade -y -qq \
        && apt-get dist-upgrade -y -qq \
        && rm -rf /var/lib/apt/lists/*
{% endblock -%}
