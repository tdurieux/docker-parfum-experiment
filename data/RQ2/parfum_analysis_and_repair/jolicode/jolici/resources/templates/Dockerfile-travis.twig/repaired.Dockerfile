{% extends "Dockerfile.twig" %}

{% block env %}
{% for key,value in global_env %}
ENV {{ key }}={{ value }}
{% endfor %}

{% for key,value in env %}
ENV {{ key }} {{ value }}
{% endfor %}
{% endblock %}

{% block before_install %}
    {% for line in before_install %}
RUN /bin/bash -c -l "cd $WORKDIR && {{ line|replace({"$": "\\\$", '"': '\\\"'}) }}"
    {% endfor %}
{% endblock %}

{% block install %}
    {% for line in install %}
RUN /bin/bash -c -l "cd $WORKDIR && {{ line|replace({"$": "\\\$", '"': '\\\"'}) }}"
    {% endfor %}
{% endblock %}

{% block before_script %}
    {% for line in before_script %}
RUN /bin/bash -c -l "cd $WORKDIR && {{ line|replace({"$": "\\\$", '"': '\\\"'}) }}"
    {% endfor %}
{% endblock %}

{% block script %}
CMD /bin/bash -c -l "cd $WORKDIR{% for line in script %} && {{ line|replace({"$": "\\\$", '"': '\\\"'}) }}{% endfor %}"
{% endblock %}