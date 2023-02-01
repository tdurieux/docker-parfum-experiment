{% extends "php/Dockerfile.twig" %}

{% block env %}
{{ parent() }}
ENV TRAVIS_PHP_VERSION php5.4
{% endblock %}

{% block from %}
FROM jolicode/php54:latest
{% endblock %}