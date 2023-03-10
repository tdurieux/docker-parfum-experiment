{{ docker.from("php", "7.4") }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php.officialDevelopment(version="7.4") }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}