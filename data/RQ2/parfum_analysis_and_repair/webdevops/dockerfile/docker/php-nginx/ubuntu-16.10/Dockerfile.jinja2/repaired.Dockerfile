{{ docker.from("php", "ubuntu-16.10") }}

{{ environment.web() }}
{{ environment.webPhp() }}
{{ environment.nginx() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ nginx.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}