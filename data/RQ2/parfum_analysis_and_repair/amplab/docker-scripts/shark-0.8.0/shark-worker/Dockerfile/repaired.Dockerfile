# Shark worker
FROM shark-base:0.8.0
MAINTAINER amplab amp-docker@eecs.berkeley.edu

# Add run script
ADD files /root/shark_worker_files

# Add the entrypoint script for the worker