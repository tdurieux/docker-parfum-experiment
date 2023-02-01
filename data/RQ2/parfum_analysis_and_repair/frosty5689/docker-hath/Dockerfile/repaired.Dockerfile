# see hooks/build and hooks/.config
ARG BASE_IMAGE_PREFIX
FROM ${BASE_IMAGE_PREFIX}openjdk:8-jre-alpine

# see hooks/post_checkout