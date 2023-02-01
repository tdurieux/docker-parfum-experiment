################################################
################################################
## Dockerfile to run MegaLinter (Quick mode) ##
################################################
################################################

##################
# Get base image #
##################
ARG MEGALINTER_BASE_IMAGE=oxsecurity/megalinter:beta
FROM $MEGALINTER_BASE_IMAGE

######################
# Set the entrypoint #
######################
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

################################
# Installs python dependencies #
################################
COPY megalinter /megalinter
RUN python /megalinter/setup.py install \
    && python /megalinter/setup.py clean --all \
    && rm -rf /var/cache/apk/*
#######################################
# Copy scripts and rules to container #
#######################################
COPY megalinter/descriptors /megalinter-descriptors
COPY TEMPLATES /action/lib/.automation

###########################
# Get the build arguments #
###########################
ARG BUILD_DATE
ARG BUILD_REVISION
ARG BUILD_VERSION

#################################################
# Set ENV values used for debugging the version #
#################################################
ENV BUILD_DATE=$BUILD_DATE \
    BUILD_REVISION=$BUILD_REVISION \
    BUILD_VERSION=$BUILD_VERSION

ENV MEGALINTER_FLAVOR=all

#########################################
# Label the instance and set maintainer #
#########################################