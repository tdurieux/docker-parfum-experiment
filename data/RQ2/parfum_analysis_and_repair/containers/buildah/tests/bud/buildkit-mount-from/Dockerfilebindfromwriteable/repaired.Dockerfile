FROM alpine
# use from=<image> as mount source
RUN --mount=type=bind,source=.,from=buildkitbase,target=/test,rw echo "world" > /test/hello && cat /test/hello