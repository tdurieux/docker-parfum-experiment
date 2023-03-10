{{ docker.from("base-app", "centos-7") }}

{{ environment.web() }}
{{ environment.phpComposerVersion() }}

{{ docker.copy('conf/', '/opt/docker/') }}

RUN set -x \
    {{ php7.centosWebtatic() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}

{{ docker.expose('9000') }}