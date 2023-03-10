{{ docker.from("php", "ubuntu-15.04") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php5dev.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}