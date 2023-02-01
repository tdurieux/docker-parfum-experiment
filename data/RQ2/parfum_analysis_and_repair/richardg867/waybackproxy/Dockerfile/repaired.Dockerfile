# Dockerfile
#
# Project: WaybackProxy
# License: GNU GPLv3
#

FROM python:3

MAINTAINER richardg867
LABEL description = "HTTP Proxy for tunneling requests through the Internet Archive Wayback Machine"

# Setup config.py