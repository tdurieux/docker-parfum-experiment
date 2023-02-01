FROM alpine as builder
COPY hello .

FROM alpine as builder2
COPY hello2 .

FROM alpine
RUN mkdir /test
# use other stages as cache source
RUN --mount=type=cache,from=builder,target=/test --mount=type=cache,from=builder2,target=/test2 cat /test2/hello2 && cat /test/hello