FROM alpine as builder
RUN mkdir subdir
COPY hello .

FROM alpine as second
RUN mkdir /test
# use another stage as cache source
RUN --mount=type=cache,from=builder,target=/test cat /test/hello