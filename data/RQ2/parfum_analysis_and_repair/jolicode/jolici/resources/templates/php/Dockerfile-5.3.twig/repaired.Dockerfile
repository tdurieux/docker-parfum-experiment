{% extends "php/Dockerfile.twig" %}

{% block env %}
{{ parent() }}
ENV TRAVIS_PHP_VERSION php5.3
{% endblock %}

{% block from %}
FROM jolicode/php53:latest
{% endblock %}