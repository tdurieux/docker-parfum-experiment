{{ docker.from("base", "debian-10") }}

{{ environment.baseApp() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ baseapp.debian10() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}