{{ docker.from("php", "debian-9") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php7dev.debian() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}