{{ baselayout.dockerStage() }}

{{ docker.fromOfficial("ubuntu", "17.10") }}

{{ docker.version() }}

{{ environment.general() }}

{{ baselayout.copy() }}

RUN set -x \
    {{ bootstrap.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}