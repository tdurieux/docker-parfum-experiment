FROM {{ "ci-buster" | image_tag }}

USER nobody
WORKDIR /src
ENTRYPOINT ["/utils/ci-src-setup.sh"]