FROM alpine
# use from=<image> as mount source
RUN --mount=type=bind,source=.,from=buildkitbase,target=/test cat /test/hello