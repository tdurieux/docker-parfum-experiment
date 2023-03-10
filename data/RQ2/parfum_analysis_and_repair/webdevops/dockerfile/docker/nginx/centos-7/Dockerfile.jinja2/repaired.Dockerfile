{{ docker.from("base", "centos-7") }}

{{ environment.web() }}
{{ environment.nginx() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ nginx.centos() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}