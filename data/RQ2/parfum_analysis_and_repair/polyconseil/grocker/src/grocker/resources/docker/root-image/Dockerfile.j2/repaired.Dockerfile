FROM {{ base_image }}
LABEL grocker.runtime={{ runtime }}

ENV LANG=C.UTF-8 \
    GROCKER_VERSION={{ grocker_version }} \
    GROCKER_RUNTIME={{ runtime }}

# Copy all files to /tmp/grocker
COPY . /tmp/grocker/

# Do provisioning
ARG SYSTEM_DEPENDENCIES
RUN /bin/sh /tmp/grocker/provision.sh