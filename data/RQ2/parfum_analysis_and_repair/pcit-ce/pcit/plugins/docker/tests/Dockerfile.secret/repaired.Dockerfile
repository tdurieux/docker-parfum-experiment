# syntax=docker/dockerfile:experimental

FROM alpine

ARG a

ARG b

RUN echo ${a} \
    && echo ${b}

RUN --mount=type=secret,id=mysecret,target=/foobar \
    set -x \
    && cat /foobar