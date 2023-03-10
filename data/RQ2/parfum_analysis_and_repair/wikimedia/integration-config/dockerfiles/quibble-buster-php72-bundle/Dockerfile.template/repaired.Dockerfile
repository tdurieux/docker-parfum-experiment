FROM {{ "quibble-buster-php72" | image_tag }}

USER root

RUN {{ "ffmpeg build-essential rubygems-integration ruby ruby-dev bundler" | apt_install }}

COPY mwselenium.sh /usr/local/bin/mwselenium

# Unprivileged
USER nobody
WORKDIR /workspace
ENTRYPOINT ["quibble-with-supervisord", "--commands", "mwselenium"]