ARG FOO=latest
FROM alpine
RUN echo "$FOO"

FROM centos:$FOO
ARG FOO
RUN echo "$FOO"