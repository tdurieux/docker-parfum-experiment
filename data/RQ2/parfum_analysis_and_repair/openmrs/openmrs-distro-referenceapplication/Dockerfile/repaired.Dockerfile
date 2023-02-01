# syntax=docker/dockerfile:1

### Dev Stage
FROM openmrs/openmrs-core:dev as dev
WORKDIR /app

ENV MVN_ARGS_SETTINGS="-s /usr/share/maven/ref/settings-docker.xml"
ENV MVN_ARGS="install"

# Copy build files
COPY . ./

# Build the distro
RUN mvn $MVN_ARGS_SETTINGS $MVN_ARGS

### Run Stage
# Replace 'nightly' with the exact version of openmrs-core built for production (if available)
FROM openmrs/openmrs-core:nightly

# Do not copy the war if using the correct openmrs-core image version