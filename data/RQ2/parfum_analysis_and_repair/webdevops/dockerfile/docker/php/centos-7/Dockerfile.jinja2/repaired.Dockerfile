{{ docker.from("base-app", "centos-7") }}

{{ environment.web() }}
{{ environment.phpComposerVersion() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php5.centos() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('9000') }}