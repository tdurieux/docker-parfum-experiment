# Builds a docker image by building the sysl binary
# on Go 1.13.8 (by default) using the current workspace and then copying the bianry
# to a image and setting up the entrypoint.
#
# The produced image is published to https://hub.docker.com/r/anzbank/sysl