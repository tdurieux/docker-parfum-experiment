{{ docker.from("base", "alpine") }}

{{ environment.baseApp() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ baseapp.alpine() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}