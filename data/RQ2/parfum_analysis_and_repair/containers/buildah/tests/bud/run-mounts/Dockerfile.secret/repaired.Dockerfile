FROM alpine
RUN --mount=type=secret,id=mysecret cat /run/secrets/mysecret