FROM {{ "ci-stretch" | image_tag }}

USER nobody
WORKDIR /src
ENTRYPOINT /utils/ci-src-setup.sh && ! /usr/bin/git grep -E -I -f typos -- . ':(exclude)typos'