{{ baselayout.dockerStage() }}

{{ docker.fromOfficial("ubuntu", "12.04") }}

{{ docker.version() }}

{{ environment.general() }}

{{ baselayout.copy() }}

RUN set -x \
    {{ bootstrap.ubuntuOld() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}