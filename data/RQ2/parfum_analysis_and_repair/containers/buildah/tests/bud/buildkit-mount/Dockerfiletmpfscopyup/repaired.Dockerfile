FROM alpine

# As a baseline, this should succeed without creating any directory on container
RUN --mount=type=tmpfs,target=/etc/ssl,tmpcopyup ls /etc/ssl