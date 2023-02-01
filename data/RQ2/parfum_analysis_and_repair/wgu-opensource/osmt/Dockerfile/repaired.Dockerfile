###########################
## TEMPORARY BUILD IMAGE ##
###########################
FROM wguopensource/osmt-build:latest as build

# Copy in source code.
USER ${USER}
COPY --chown=${USER}:${USER} ./ ${BASE_DIR}/build/
WORKDIR ${BASE_DIR}/build

# The dockerfile-build Maven profile excludes certain api integration tests that require access to the Docker service.
RUN mvn clean install -P dockerfile-build

######################
## SPRING APP IMAGE ##
######################