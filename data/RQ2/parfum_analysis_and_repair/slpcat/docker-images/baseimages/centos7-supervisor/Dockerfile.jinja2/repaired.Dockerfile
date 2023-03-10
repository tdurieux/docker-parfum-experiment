{{ docker.from("bootstrap", "centos-7") }}

{{ environment.base() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ base.centos() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.entrypoint("/entrypoint") }}
{{ docker.cmd("supervisord") }}