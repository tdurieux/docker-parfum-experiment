# Expecting base image to be the image built by ../cu112/Dockerfile.gpu e3 target
ARG BASE_IMAGE=""

FROM $BASE_IMAGE

# Add any script or repo as required