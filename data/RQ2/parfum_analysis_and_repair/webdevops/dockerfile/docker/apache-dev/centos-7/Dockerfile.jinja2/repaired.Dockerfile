{{ docker.from("apache", "centos-7") }}

{{ environment.webDevelopment() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ apachedev.general() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('80 443') }}