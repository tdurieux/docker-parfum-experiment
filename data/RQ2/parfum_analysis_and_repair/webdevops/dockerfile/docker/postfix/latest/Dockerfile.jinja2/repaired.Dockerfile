{{ docker.from("base-app") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ postfix.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('25 465 587') }}