{{ docker.from("base", "centos-7") }}

{{ environment.baseApp() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ baseapp.centos() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}