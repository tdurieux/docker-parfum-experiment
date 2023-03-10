FROM alpine:3.12.0

RUN apk add --no-cache libssl nonexistent fixture

RUN apk remove foo

RUN echo "mock dockerfile"

USER bar

ENTRYPOINT [ "not", "-a", "--real", "dockerfile" ]
