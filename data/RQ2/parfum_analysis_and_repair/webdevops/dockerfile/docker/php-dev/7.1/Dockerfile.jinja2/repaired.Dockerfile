{{ docker.from("php", "7.1") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php.officialDevelopment(version="7.1") }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}