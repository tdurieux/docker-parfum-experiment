{{ docker.from("bootstrap", "ubuntu-17.10") }}

{{ environment.base() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ base.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.entrypoint("/entrypoint") }}
{{ docker.cmd("supervisord") }}