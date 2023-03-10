{{ baselayout.dockerStage() }}

{{ docker.fromOfficial("ubuntu", "15.10") }}

{{ docker.version() }}

{{ environment.general() }}

{{ baselayout.copy() }}

RUN set -x \
    {{ bootstrap.ubuntuOld() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}