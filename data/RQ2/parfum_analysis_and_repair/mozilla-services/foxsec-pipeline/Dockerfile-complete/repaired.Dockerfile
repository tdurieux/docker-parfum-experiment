# Dockerfile used to build the foxsec-pipeline image.
#
# This is the complete image, based off the base image but also containing
# source code and compiled classes.

FROM foxsec-pipeline-base:latest

# Add a set of layers to the image that act as a dependency cache; copy just
# what is required to resolve the dependencies such that the cache will be
# invalidated if the dependencies change.