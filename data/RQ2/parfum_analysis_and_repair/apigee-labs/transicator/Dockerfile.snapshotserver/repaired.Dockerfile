# Build and run the snapshot server.
#
# This image will launch the server with the default port (port 9000) open.
#
# To run, add the "-u" argument, which takes a postgres URL.
#
# For instance:
#
# docker run --rm -t snapshotserver -u postgres://user:pass@host/databasename?ssl=false