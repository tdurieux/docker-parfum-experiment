FROM alpine
RUN mkdir /test
# use from=<image> as mount source
RUN --mount=type=bind,from=buildkitbase,target=/test cat /test/hello