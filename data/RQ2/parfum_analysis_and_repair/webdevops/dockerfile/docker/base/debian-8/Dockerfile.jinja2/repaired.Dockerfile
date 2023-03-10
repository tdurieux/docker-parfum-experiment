{{ docker.from("bootstrap", "debian-8") }}

{{ environment.base() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ base.debian() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.entrypoint("/entrypoint") }}
{{ docker.cmd("supervisord") }}