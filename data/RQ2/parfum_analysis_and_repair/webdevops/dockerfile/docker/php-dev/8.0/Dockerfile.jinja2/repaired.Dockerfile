{{ docker.from("php", "8.0") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php.officialDevelopment(version="8.0") }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}