{% extends "php/Dockerfile.twig" %}

{% block env %}
{{ parent() }}
ENV TRAVIS_PHP_VERSION php7.0-dev
{% endblock %}

{% block from %}
FROM jolicode/php-master:latest
{% endblock %}