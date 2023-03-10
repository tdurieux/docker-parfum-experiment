{{ docker.from("php", "debian-10") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php7dev.debian() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}