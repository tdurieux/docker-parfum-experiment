###############################################################################
# This dockerfile is meant to build the production image of ldmx-sw
#   for the development image, look at the LDMX-Software/docker repo
###############################################################################

ARG DEV_TAG=v2.0
FROM ldmx/dev:${DEV_TAG}

# install ldmx-sw into the container at /usr/local