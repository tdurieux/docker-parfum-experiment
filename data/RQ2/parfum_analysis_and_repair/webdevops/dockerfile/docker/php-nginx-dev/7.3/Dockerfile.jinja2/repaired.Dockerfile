{{ docker.from("php-nginx", "7.3") }}

{{ environment.web() }}
{{ environment.webPhp() }}
{{ environment.webDevelopment() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php.officialDevelopment(version="7.3") }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}