{{ docker.from("base", "debian-9") }}

{{ environment.web() }}
{{ environment.nginx() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ nginx.debian() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}