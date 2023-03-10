FROM {{ base_image }}
LABEL grocker.app.name={{ app_name }} \
      grocker.app.extras={{ app_extras }} \
      grocker.app.version={{ app_version }}

ENV GROCKER_APP={{ app_name }} \
    GROCKER_APP_EXTRAS={{ app_extras }} \
    GROCKER_APP_VERSION={{ app_version }} \
    PATH=/home/grocker/app.venv/bin/:${PATH}

# Provisioning
ARG GROCKER_WHEEL_SERVER_IP
COPY . /tmp/grocker
RUN /bin/sh /tmp/grocker/provision.sh

# Ports and Volumes
{% if ports %}EXPOSE{% for port in ports %} {{ port }}{% endfor %}{% endif %}
{% if volumes %}VOLUME {{volumes | jsonify }}{% endif %}
{% if envs %}ENV {% for key, value in envs.items()%}{{ key }}="{{ value }}" {% endfor %}{% endif %}

# Make the entry point run the compile script
USER grocker
WORKDIR /home/grocker
ENTRYPOINT ["{{ entrypoint_name }}"]