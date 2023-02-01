FROM alpine
RUN apk --no-cache add py-pip && pip install --no-cache-dir transifex-client
ENTRYPOINT ["tx"]
