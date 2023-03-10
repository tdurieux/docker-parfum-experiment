{{ docker.from("base", "debian-8") }}

{{ environment.web() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ apache.debian8() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}