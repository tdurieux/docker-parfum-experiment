{{ docker.from("apache", "ubuntu-17.10") }}

{{ environment.webDevelopment() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ apachedev.general() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}