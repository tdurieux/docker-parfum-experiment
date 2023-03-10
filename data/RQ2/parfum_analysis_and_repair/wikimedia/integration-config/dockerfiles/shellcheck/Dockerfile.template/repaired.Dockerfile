FROM {{ "ci-buster" | image_tag }}

USER root

RUN {{ "shellcheck" | apt_install }}

COPY run.sh /run.sh

USER nobody
WORKDIR /src
ENTRYPOINT ["/run.sh"]