FROM {{ "composer-php73" | image_tag }}

USER nobody
COPY run.sh /run.sh
ENTRYPOINT ["/run.sh"]