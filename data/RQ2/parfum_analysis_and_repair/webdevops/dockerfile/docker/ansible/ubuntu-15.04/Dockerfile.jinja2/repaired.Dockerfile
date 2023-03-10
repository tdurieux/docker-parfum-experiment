{{ docker.from("bootstrap", "ubuntu-15.04") }}

RUN set -x \
    {{ ansible.ubuntu() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}