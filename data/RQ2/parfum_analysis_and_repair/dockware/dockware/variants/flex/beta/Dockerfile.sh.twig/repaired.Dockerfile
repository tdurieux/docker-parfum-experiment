{% extends "variants/flex/Dockerfile.base.sh.twig" %}


{% block components_grunt %}
{{ parent() }}
RUN apt-get update && \
    apt-get install --no-install-recommends -y python python2.7 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*
{% endblock %}