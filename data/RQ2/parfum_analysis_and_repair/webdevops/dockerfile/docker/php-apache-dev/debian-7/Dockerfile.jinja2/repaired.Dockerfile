{{ docker.from("php-apache", "debian-7") }}

{{ environment.web() }}
{{ environment.webPhp() }}
{{ environment.webDevelopment() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php5dev.debian() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}