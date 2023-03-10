{{ docker.from("bootstrap", "debian-7") }}

RUN set -x \
    {{ ansible.debian() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}