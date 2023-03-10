# syntax=docker/dockerfile:experimental

ARG BASE_IMAGE
ARG BUILDER_IMAGE
FROM ${BASE_IMAGE} as base

FROM scratch as deps

COPY --from=base /usr/include/git2 ./usr/include/git2
COPY --from=base /usr/include/git2.h ./usr/include
COPY --from=base /usr/lib64/pkgconfig/*.pc ./usr/lib64/pkgconfig/
COPY --from=base /usr/lib64/libgit2* ./usr/lib64
COPY --from=base /usr/lib64/libssh2* ./usr/lib64