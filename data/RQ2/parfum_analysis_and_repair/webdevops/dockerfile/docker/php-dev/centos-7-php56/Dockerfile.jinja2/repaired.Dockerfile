{{ docker.from("php", "centos-7-php56") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php5dev.webtatic() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}