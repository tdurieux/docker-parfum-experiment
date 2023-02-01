# This dockerfile makes sure the .dockerignore is working
# If so then ignore/foo should copy to /foo
# If not, then this image won't build because it will attempt to copy three files to /foo, which is a file not a directory
FROM scratch as base
COPY ignore/* /foo

From base as first
COPY --from=base /foo ignore/bar

# Make sure that .dockerignore also applies for later stages