FROM alpine
RUN --mount=type=secret,id=mysecret stat -c "%a" /run/secrets/mysecret