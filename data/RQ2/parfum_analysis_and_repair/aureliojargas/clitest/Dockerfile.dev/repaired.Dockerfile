# clitest-dev
# Local Docker image used for clitest development.
#
# It has all the required tools for linting and testing clitest code.
# See Makefile for commands to build and run this image.
#
# If you're searching for the official clitest Docker image (for users):
# https://hub.docker.com/r/aureliojargas/clitest

FROM alpine:3.12

# Perl is required by clitest's --regex matching mode