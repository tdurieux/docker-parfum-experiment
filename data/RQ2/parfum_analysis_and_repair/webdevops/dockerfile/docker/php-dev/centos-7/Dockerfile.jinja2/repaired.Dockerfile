{{ docker.from("php", "centos-7") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php5dev.centos() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}