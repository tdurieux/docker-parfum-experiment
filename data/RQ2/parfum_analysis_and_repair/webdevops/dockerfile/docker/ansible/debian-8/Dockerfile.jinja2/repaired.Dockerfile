{{ docker.from("bootstrap", "debian-8") }}

RUN set -x \
    {{ ansible.debian() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}