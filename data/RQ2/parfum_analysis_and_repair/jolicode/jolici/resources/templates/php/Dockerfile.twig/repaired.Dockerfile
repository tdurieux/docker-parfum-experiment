{% extends "Dockerfile-travis.twig" %}

{% block env %}
{{ parent() }}
{% endblock %}

{% block before_install %}
RUN echo 'date.timezone={{ timezone }}' >> /home/.phpenv/versions/`cat /home/.phpenv/version`/etc/php.ini
{% endblock %}