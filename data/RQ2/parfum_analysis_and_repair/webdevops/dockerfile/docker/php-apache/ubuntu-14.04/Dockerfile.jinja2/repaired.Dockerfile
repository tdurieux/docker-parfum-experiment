{{ docker.from("php", "ubuntu-14.04") }}

{{ environment.web() }}
{{ environment.webPhp() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ apache.ubuntu14() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}