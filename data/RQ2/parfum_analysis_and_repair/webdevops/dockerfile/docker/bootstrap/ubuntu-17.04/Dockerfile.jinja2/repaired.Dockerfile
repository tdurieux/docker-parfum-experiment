{{ baselayout.dockerStage() }}

{{ docker.fromOfficial("ubuntu", "17.04") }}

{{ docker.version() }}

{{ environment.general() }}

{{ baselayout.copy() }}

RUN set -x \
    {{ bootstrap.ubuntuOld() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}