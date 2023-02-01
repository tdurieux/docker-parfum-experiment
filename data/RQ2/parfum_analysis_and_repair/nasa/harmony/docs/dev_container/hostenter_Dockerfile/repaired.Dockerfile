FROM alpine
RUN apk update && \
    apk add --no-cache util-linux && \
    rm -rf /var/cache/apk/*
ENTRYPOINT ["nsenter", "--target", "1", "--mount", "--uts", "--ipc", "--net", "--pid"]

