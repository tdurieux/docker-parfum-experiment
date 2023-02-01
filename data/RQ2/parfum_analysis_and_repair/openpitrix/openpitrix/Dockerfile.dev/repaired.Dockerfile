FROM alpine:3.7

COPY ./hyperpitrix /usr/local/bin/

RUN apk add --no-cache --update ca-certificates && \
    update-ca-certificates && \
    adduser -D -g openpitrix -u 1002 openpitrix && \
    chown -R openpitrix:openpitrix /usr/local/bin/
USER openpitrix

CMD ["sh"]
