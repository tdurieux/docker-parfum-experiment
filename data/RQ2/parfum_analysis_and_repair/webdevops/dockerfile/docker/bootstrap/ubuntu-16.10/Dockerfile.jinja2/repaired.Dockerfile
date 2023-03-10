{{ baselayout.dockerStage() }}

{{ docker.fromOfficial("ubuntu", "16.10") }}

{{ docker.version() }}

{{ environment.general() }}

{{ baselayout.copy() }}

RUN set -x \
    {{ bootstrap.ubuntuOld() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}