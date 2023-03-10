{% block from %}
FROM jolicode/base:latest
{% endblock %}

{% block content %}
{% endblock %}

LABEL com.jolici.image="true"
ENV WORKDIR $HOME/project
ADD . $WORKDIR
WORKDIR $HOME/project
RUN sudo chown travis:travis -R $HOME/project

{% block env %}{% endblock %}

{% block before_install %}{% endblock %}

{% block install %}{% endblock %}

{% block before_script %}{% endblock %}

{% block script %}{% endblock %}