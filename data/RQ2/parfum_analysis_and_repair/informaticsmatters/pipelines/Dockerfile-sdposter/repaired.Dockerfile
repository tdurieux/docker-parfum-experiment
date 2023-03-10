FROM centos:7
MAINTAINER Tim Dudgeon <tdudgeon@informaticsmatters.com>

# The image tag for the pipelines we're expected to post.
# By default this is 'latest' but the build environment can
# use a built-arg to over-ride this.
# So, a poster container image built for Git tag '1.0.0' would be expected
# to have its IMAGE_TAG environment variable set to '1.0.0' and therefore
# running poster:1.0.0 would inject pipelines for container image '1.0.0'
ARG image_tag=latest
ENV IMAGE_TAG=$image_tag

# An image to populate the Core with the contents of the
# Service Descriptors located in SD_SRC.

ENV SD_SRC /sd-src
WORKDIR ${SD_SRC}

# Copy all potential Service Descriptors into the image...
COPY src/python/ ${SD_SRC}/src/python/
COPY src/nextflow/ ${SD_SRC}/src/nextflow/
COPY post-service-descriptors.sh ${SD_SRC}/
RUN chmod 755 post-service-descriptors.sh

# On execution copy files from source to destination...
CMD ./post-service-descriptors.sh