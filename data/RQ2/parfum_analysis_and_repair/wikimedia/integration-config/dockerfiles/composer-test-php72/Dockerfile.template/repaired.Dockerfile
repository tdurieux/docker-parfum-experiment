FROM {{ "composer-php72" | image_tag }}

USER nobody
COPY run.sh /run.sh
ENTRYPOINT ["/run.sh"]