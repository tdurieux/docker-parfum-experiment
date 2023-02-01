# cpppo/base Dockerfile.
#
# DESCRIPTION
#     Base image for all cpppo/* images.
#
# EXAMPLE
#
#     Build a new image.  Using the GNUmakefile 'update' target updates any '#
# YYYY-MM-DD' dated lines in the Dockerfile so that out-of-date cached images
# won't be used:
#
#   $ docker build -t cpppo/base cpppo/base		# or: 'make update' in ../..
#
FROM		stackbrew/debian:jessie
MAINTAINER	Perry Kundert "perry@hardconsulting.com"
# Redirect http://.../debian to CA mirror, but leave http://security.debian.org/