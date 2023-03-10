{{ docker.from("php", "debian-7") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php5dev.debian() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}