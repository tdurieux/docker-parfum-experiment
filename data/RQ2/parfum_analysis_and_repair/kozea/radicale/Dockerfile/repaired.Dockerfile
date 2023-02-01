# This file is intended to be used apart from the containing source code tree.

FROM python:3-alpine

# Version of Radicale (e.g. v3)
ARG VERSION=master
# Persistent storage for data
VOLUME /var/lib/radicale
# TCP port of Radicale
EXPOSE 5232
# Run Radicale