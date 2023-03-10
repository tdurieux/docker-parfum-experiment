{{ docker.from("php-nginx", "centos-7-php56") }}

{{ environment.web() }}
{{ environment.webPhp() }}
{{ environment.webDevelopment() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php5dev.webtatic() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}