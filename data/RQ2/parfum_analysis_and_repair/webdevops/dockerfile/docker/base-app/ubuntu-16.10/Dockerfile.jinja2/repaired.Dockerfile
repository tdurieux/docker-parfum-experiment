{{ docker.from("base", "ubuntu-16.10") }}

{{ environment.baseApp() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ baseapp.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}