{{ docker.from("php", "debian-8-php7") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php7dev.debianSury() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}