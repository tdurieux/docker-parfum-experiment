{% extends "php/Dockerfile.twig" %}

{% block env %}
{{ parent() }}
ENV TRAVIS_PHP_VERSION php5.6
{% endblock %}

{% block from %}
FROM jolicode/php56:latest
{% endblock %}