{{ baselayout.dockerStage() }}

{{ docker.fromOfficial("ubuntu", "14.04") }}

{{ docker.version() }}

{{ environment.general() }}

{{ baselayout.copy() }}

RUN set -x \
    {{ bootstrap.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}