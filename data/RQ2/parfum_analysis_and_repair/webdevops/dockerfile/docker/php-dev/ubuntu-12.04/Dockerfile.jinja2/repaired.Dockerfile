{{ docker.from("php", "ubuntu-12.04") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php5dev.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}