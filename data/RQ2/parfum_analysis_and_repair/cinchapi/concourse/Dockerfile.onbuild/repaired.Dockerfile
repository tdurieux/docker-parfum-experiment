FROM cinchapi/concourse

# The directory that is included should have a directory called "plugins" which
# contains all the plugins that will be installed when the image is built.
ONBUILD ARG INCLUDE=.

# Copy the INCLUDE directory to the image
ONBUILD COPY ${INCLUDE} /usr/src/include

# Ensure that the expected directories exist, even if empty
 \
RUN mkdir -p /usr/src/include/plugins && rm -rf /usr/src/include/pluginsONBUILD
 \
RUN mkdir -p /usr/src/include/data && rm -rf /usr/src/include/dataONBUILD

# Install plugins from the INCLUDE directory
ONBUILD RUN concourse start && \
        concourse plugin install /usr/src/include/plugins --password admin \
        concourse stop
