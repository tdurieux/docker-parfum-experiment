{{ docker.from("base", "debian-7") }}

{{ environment.web() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ apache.debian7() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}