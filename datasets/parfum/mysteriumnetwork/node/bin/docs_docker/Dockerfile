FROM redocly/redoc AS docs

COPY tequilapi/docs/swagger.json /usr/share/nginx/html/tequilapi.json

ENV SPEC_URL='/tequilapi.json'

RUN chmod 755 /usr/local/bin/docker-run.sh

ENTRYPOINT ["/usr/local/bin/docker-run.sh"]
