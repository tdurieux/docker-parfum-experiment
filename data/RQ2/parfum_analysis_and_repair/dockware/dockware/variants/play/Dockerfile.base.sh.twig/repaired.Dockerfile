{% extends "template/Dockerfile.global.sh.twig" %}


{% block image_variables_mysql %}
{% endblock %}

{% block image_variables_dev %}
{% endblock %}


{# simply dont allow ssh user, but we still need it #}
{% block ssh_user_allow %}
{% endblock %}

{% block components_dev_tools %}
{% endblock %}

{% block components_npm %}
{% endblock %}

{% block components_node %}
{% endblock %}

{% block components_grunt %}
{% endblock %}

{% block components_xdebug %}
{% endblock %}

{% block components_packagers %}
{% endblock %}

{% block components_filebeat %}
{% endblock %}

{% block components_tideways %}
{% endblock %}

{% block components_packagers_yarn %}
{% endblock %}

{% block shopware_dev %}
{% endblock %}