ARG VERSION=latest
ARG FOO=bar
FROM busybox:$VERSION
ENV FOO $FOO
RUN echo $FOO $VERSION