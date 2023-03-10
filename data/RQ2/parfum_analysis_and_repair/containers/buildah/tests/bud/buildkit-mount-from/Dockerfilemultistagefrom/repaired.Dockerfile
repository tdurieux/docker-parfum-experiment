FROM alpine as builder
RUN mkdir subdir
COPY hello ./subdir/

FROM alpine as second
RUN --mount=type=bind,source=/subdir,from=builder,target=/test cat /test/hello