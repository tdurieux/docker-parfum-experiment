{{ docker.from("base", "debian-8") }}

{{ environment.baseApp() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ baseapp.debian() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}