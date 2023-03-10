{{ docker.from("bootstrap", "ubuntu-14.04") }}

RUN set -x \
    {{ ansible.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}