# syntax=docker/dockerfile:1
# The cross-built images have the build arch (`amd64`) embedded in the image
# manifest, rather than the target arch. For example:
#
#   $ docker inspect vaultwarden/server:latest-armv7 | jq -r '.[]|.Architecture'
#   amd64
#
# Recent versions of Docker have started printing a warning when the image's
# claimed arch doesn't match the host arch. For example:
#
#   WARNING: The requested image's platform (linux/amd64) does not match the
#   detected host platform (linux/arm/v7) and no specific platform was requested
#
# The image still works fine, but the spurious warning creates confusion.
#
# Docker doesn't seem to provide a way to directly set the arch of an image
# at build time. To resolve the build vs. target arch discrepancy, we use
# Docker Buildx to build a new set of images with the correct target arch.
#
# Docker Buildx uses this Dockerfile to build an image for each requested
# platform. Since the Dockerfile basically consists of a single `FROM`
# instruction, we're effectively telling Buildx to build a platform-specific
# image by simply copying the existing cross-built image and setting the
# correct target arch as a side effect.
#
# References:
#
# - https://docs.docker.com/buildx/working-with-buildx/#build-multi-platform-images
# - https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
# - https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
#