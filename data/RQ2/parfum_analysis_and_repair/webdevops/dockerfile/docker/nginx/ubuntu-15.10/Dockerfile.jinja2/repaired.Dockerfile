{{ docker.from("base", "ubuntu-15.10") }}

{{ environment.web() }}
{{ environment.nginx() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ nginx.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}