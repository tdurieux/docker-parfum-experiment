FROM alpine
RUN mkdir /test
# use option z if selinux is enabled
RUN --mount=type=bind,source=.,target=/test,z cat /test/input_file
