{{ docker.from("php-nginx", "centos-7-php7") }}

{{ environment.web() }}
{{ environment.webPhp() }}
{{ environment.webDevelopment() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php7dev.webtatic() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}