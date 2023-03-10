{{ docker.from("base", "debian-9") }}

{{ environment.web() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ apache.debian9() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}