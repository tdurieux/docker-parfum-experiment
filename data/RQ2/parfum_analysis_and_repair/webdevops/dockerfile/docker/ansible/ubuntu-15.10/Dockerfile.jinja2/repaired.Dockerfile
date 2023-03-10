{{ docker.from("bootstrap", "ubuntu-15.10") }}

RUN set -x \
    {{ ansible.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}