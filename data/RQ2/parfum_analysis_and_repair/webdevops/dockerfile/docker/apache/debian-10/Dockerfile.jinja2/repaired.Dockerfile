{{ docker.from("base", "debian-10") }}

{{ environment.web() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ apache.debian10() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}