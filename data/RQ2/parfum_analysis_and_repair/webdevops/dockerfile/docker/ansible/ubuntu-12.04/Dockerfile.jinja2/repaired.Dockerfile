{{ docker.from("bootstrap", "ubuntu-12.04") }}

RUN set -x \
    {{ ansible.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}