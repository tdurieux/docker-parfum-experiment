FROM alpine

# As a baseline, this should succeed without creating any directory on container
RUN --mount=type=tmpfs,target=/var/tmpfs-not-empty touch /var/tmpfs-not-empty/hello