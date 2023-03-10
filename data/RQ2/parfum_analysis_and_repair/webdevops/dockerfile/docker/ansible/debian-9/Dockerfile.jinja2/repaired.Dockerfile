{{ docker.from("bootstrap", "debian-9") }}

RUN set -x \
    {{ ansible.debian() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}