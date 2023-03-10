{{ docker.from("php", "7.1-alpine") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php.officialDevelopmentAlpine(version="7.1") }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}