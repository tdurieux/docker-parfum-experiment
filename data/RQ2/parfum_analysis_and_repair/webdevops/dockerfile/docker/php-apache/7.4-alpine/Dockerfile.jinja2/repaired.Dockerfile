{{ docker.from("php", "7.4-alpine") }}

{{ environment.web() }}
{{ environment.webPhp() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ apache.alpine() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}