FROM {{ "composer-php80" | image_tag }}

USER nobody
COPY run.sh /run.sh
ENTRYPOINT ["/run.sh"]