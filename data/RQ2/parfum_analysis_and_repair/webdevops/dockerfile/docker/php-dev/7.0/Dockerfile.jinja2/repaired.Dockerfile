{{ docker.from("php", "7.0") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php.officialDevelopment(version="7.0") }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}