{{ docker.from("base", "debian-9") }}

{{ environment.baseApp() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ baseapp.debian9() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}