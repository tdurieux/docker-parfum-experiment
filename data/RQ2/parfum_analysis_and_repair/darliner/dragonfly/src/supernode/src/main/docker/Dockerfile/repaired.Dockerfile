# We use this stage for minimizing layers
FROM busybox:latest as SRC
# Copy sources
COPY sources /tmp/sources

FROM centos:7

# That's all we need