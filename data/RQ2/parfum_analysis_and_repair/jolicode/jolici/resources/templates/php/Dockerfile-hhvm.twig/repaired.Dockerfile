{% extends "Dockerfile-travis.twig" %}

{% block from %}
FROM jolicode/hhvm:latest
{% endblock %}

{% block env %}
{{ parent() }}
ENV TRAVIS_PHP_VERSION hhvm
{% endblock %}

{% block before_install %}
RUN echo 'date.timezone={{ timezone }}' | sudo tee -a /etc/hhvm/php.ini
{% endblock %}