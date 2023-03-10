{{ docker.from("php", "ubuntu-17.04") }}

{{ environment.web() }}
{{ environment.webPhp() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ apache.ubuntu16() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}