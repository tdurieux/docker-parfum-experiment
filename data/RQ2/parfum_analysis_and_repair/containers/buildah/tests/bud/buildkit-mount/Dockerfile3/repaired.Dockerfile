FROM alpine
RUN mkdir /test
# use option z if selinux is enabled
RUN --mount=type=bind,source=.,target=/test,z,rw echo world > /test/input_file && cat /test/input_file