FROM alpine
RUN mkdir /test
# use from=<image> as mount source
RUN --mount=type=bind,source=.,from=,target=/test cat /test/hello