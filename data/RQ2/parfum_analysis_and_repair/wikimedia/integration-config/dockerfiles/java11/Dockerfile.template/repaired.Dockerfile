FROM {{ "ci-buster" | image_tag }}

RUN {{ "openjdk-11-jdk-headless" | apt_install }}

USER nobody
WORKDIR /src
ENTRYPOINT ["java"]