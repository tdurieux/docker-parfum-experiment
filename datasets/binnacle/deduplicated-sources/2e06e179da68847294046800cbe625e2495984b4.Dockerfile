FROM {{ "tox" | image_tag }}

USER root
RUN {{ "libldap2-dev libsasl2-dev libssl-dev" | apt_install }}

USER nobody
