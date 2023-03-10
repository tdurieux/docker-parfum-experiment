{{ docker.from("php", "5.6") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php.officialDevelopment(version="5.6") }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}