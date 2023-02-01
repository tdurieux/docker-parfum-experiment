# Start with busybox, but with libc.so.6
FROM busybox:ubuntu-14.04

MAINTAINER Michael Stapelberg <michael@robustirc.net>

# So that we can run as unprivileged user inside the container.