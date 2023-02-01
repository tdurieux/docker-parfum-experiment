# GuestOS - Dev Docker Image
#
# Adds an additional layer on top of the prod image, to include any
# system changes that should be included ONLY in the DEV image.
#
# Build steps:
# - `docker build -t dfinity/guestos-dev -f Dockerfile.dev . --build-arg <PREVIOUS_IMAGE>`
#

# This argument MUST be given by the build script, otherwise build will fail.