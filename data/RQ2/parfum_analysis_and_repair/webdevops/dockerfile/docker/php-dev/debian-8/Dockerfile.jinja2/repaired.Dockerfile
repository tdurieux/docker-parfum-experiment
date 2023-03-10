{{ docker.from("php", "debian-8") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php5dev.debian() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}