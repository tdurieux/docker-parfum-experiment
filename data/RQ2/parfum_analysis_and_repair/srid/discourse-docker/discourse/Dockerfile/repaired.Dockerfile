# -*- sh -*-

# Base image for all Discourse related processes.

FROM ubuntu:12.04
MAINTAINER srid

# TODO: want to upgrade to 0.9.8.11, but database.yml.production-sample no
# longer exists?