# see hooks/build and hooks/.config
ARG BASE_IMAGE_PREFIX
FROM ${BASE_IMAGE_PREFIX}python:3.8-slim-buster

# see hooks/post_checkout
ARG ARCH
COPY qemu-${ARCH}-static /usr/bin

# Begin WyzeSense2MQTT