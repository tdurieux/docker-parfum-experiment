# A base image that is known to be a manifest list.
FROM docker.io/library/alpine
COPY Dockerfile.no-run /root/
# A different base image that is known to be a manifest list, supporting a
# different but partially-overlapping set of platforms.