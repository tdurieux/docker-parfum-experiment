FROM {{ "tox" | image_tag }}

USER root
RUN mkdir -p /usr/share/man/man1 && {{ "openjdk-8-jre-headless" | apt_install }}

USER nobody