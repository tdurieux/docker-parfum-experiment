FROM alpine
RUN mkdir /test
# use option z if selinux is enabled
RUN --mount=type=cache,target=/test,z cat /test/world