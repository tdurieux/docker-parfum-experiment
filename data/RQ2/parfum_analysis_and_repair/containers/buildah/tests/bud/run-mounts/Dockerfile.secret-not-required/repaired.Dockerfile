FROM alpine
RUN --mount=type=secret,id=mysecret echo "hello"