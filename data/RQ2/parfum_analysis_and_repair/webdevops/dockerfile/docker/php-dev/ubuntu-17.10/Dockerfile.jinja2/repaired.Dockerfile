{{ docker.from("php", "ubuntu-17.10") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php7dev.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}