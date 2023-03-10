{{ docker.from("base", "centos-7") }}

{{ environment.web() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ apache.centos() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}