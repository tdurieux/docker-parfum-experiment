{{ docker.from("bootstrap","alpine") }}

RUN set -x \
    {{ sphinx.alpine() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}