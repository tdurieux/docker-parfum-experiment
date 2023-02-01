FROM alpine
RUN mkdir /test
# use another image as cache source
# following should fail as cache does not supports mounting image
RUN --mount=type=cache,from=buildkitbase,target=/test cat /test/hello