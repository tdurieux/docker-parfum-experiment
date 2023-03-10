{{ docker.from("bootstrap", "ubuntu-16.04") }}

RUN set -x \
    {{ ansible.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}