FROM alpine
RUN apk add --no-cache -U git
COPY svu*.apk /tmp/
RUN apk add --no-cache --allow-untrusted /tmp/*.apk
ENTRYPOINT ["svu"]
