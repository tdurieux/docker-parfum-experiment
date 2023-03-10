{{ docker.from("base","alpine") }}

{{ varnish.env() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ varnish.alpine() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.cmd("varnishd") }}

{{ docker.expose('80') }}