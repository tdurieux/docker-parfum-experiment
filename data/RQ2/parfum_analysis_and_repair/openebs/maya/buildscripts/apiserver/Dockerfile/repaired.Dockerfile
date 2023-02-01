#
# This Dockerfile builds a recent maya api server using the latest binary from
# maya api server's releases.
#

FROM openebs/linux-utils:2.12.x-ci

# TODO: The following env variables should be auto detected.