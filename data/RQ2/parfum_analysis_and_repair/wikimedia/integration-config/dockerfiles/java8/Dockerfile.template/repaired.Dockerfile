FROM {{ "ci-stretch" | image_tag }}

RUN mkdir -p /usr/share/man/man1 && \
    {{ "openjdk-8-jdk-headless" | apt_install }}

USER nobody
WORKDIR /src
ENTRYPOINT ["java"]