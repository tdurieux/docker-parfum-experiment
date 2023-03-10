{{ docker.from("php", "7.3") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php.officialDevelopment(version="7.3") }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}