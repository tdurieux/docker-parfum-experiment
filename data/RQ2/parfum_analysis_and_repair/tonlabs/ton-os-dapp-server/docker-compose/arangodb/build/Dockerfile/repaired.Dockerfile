FROM arangodb:3.7.15

RUN apk add --no-cache bash
RUN rm /entrypoint.sh
ADD arango /arango
RUN chmod +x /arango/entrypoint
RUN mkdir -p '/var/lib/arangodb3'; \
    mkdir -p '/var/lib/arangodb3-apps'; \
    chmod +w '/var/lib/arangodb3'; \
    chmod +w '/var/lib/arangodb3-apps'
EXPOSE 80
EXPOSE 8529
ENTRYPOINT ["/arango/entrypoint"]
