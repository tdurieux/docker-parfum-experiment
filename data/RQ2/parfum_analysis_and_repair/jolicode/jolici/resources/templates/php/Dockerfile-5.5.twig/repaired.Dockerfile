{% extends "php/Dockerfile.twig" %}

{% block env %}
{{ parent() }}
ENV TRAVIS_PHP_VERSION php5.5
{% endblock %}

{% block from %}
FROM jolicode/php55:latest
{% endblock %}