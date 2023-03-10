{{ docker.from("bootstrap","alpine") }}

{{ docker.volume('/etc/letsencrypt') }}
{{ docker.volume('/var/www') }}

RUN set -x \
    {{ certbot.alpine() }} \
    {{ provision.runBootstrap() }} \
    {{ docker.cleanup() }}